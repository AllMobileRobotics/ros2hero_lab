#!/bin/bash
# เปิดเดสก์ท็อป Ubuntu ในเบราว์เซอร์ (noVNC) ที่พอร์ต 6080 — รันทุกครั้งที่ codespace เริ่ม
#
# 🔴 ทำไมไม่ปล่อยให้ image เปิดเองที่พอร์ต 80
#    image นี้รัน noVNC เป็นผู้ใช้ทั่วไป (ubuntu) ที่พอร์ต 80
#    เครื่องที่ไม่อนุญาตให้ผู้ใช้ทั่วไปเปิดพอร์ตต่ำกว่า 1024 (เช่น Codespaces) → noVNC ล้มวนซ้ำ → เปิดหน้าเดสก์ท็อปได้ HTTP 502
#    Docker บน Mac อนุญาต จึงไม่เจอตอนทดสอบในเครื่อง
PORT=6080
if curl -s -o /dev/null "http://127.0.0.1:$PORT/"; then echo "เดสก์ท็อปเปิดอยู่แล้ว (พอร์ต $PORT)"; exit 0; fi

# ใช้ตัวเริ่มของ image เอง (ตั้ง VNC · เดสก์ท็อป) แต่เปลี่ยนพอร์ต noVNC เป็น 6080
# เดสก์ท็อปรันเป็นผู้ใช้ ubuntu (เป็น root แล้วไอคอนบนเดสก์ท็อปไม่ขึ้น)
# เทอร์มินัลของ VS Code เป็น root — สองผู้ใช้คุยกันใน ROS 2 ได้เพราะบังคับ DDS ใช้ UDP (ดู FASTDDS_BUILTIN_TRANSPORTS)
sed -e "s#websockify --web=/usr/lib/novnc 80 #websockify --web=/usr/lib/novnc $PORT #" \
    -e 's#^exec /bin/tini -- supervisord#exec supervisord#' /entrypoint.sh > /tmp/r2h-entrypoint.sh
# 🔴 LANG ต้องเป็น UTF-8 — ไม่งั้นเทอร์มินัลนับความกว้างภาษาไทยผิด วางโค้ดที่มีคอมเมนต์ไทยแล้วบรรทัดทับกันอ่านไม่ออก
export LANG=C.UTF-8
USER=ubuntu PASSWORD=ubuntu nohup setsid bash /tmp/r2h-entrypoint.sh > /tmp/r2h-desktop.log 2>&1 < /dev/null &

for i in $(seq 60); do curl -s -o /dev/null "http://127.0.0.1:$PORT/" && break; sleep 1; done
if ! curl -s -o /dev/null "http://127.0.0.1:$PORT/"; then
  echo "🔴 เดสก์ท็อปเปิดไม่ขึ้น — ดู /tmp/r2h-desktop.log"; tail -20 /tmp/r2h-desktop.log; exit 1
fi

# ค่าสำหรับ lab + ไฟล์เริ่มที่นี่บนเดสก์ท็อป
# 🔴 FASTDDS_BUILTIN_TRANSPORTS=UDPv4 — ไม่ใช้ shared memory
#    shared memory ข้ามผู้ใช้ไม่ได้ (root ↔ ubuntu) → เปิดเต่าจากเทอร์มินัล VS Code แล้ว Terminator บนเดสก์ท็อปมองไม่เห็น
#    ค่าเดียวกันอยู่ใน remoteEnv ของ devcontainer.json (ฝั่งเทอร์มินัล VS Code)
for i in $(seq 30); do [ -d /home/ubuntu/Desktop ] && break; sleep 1; done
B=/home/ubuntu/.bashrc
grep -q ROS2HERO "$B" 2>/dev/null || printf '\n# ROS2HERO\nexport ROS_DOMAIN_ID=30\nexport FASTDDS_BUILTIN_TRANSPORTS=UDPv4\n' >> "$B"
cp -n "$(dirname "$0")"/../labs/*.txt /home/ubuntu/Desktop/ 2>/dev/null || true
chown -R ubuntu:ubuntu /home/ubuntu/Desktop "$B" 2>/dev/null || true
echo "✅ เดสก์ท็อปพร้อม — แท็บ Ports → พอร์ต $PORT → รูปลูกโลก → Connect"
