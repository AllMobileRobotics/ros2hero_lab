#!/bin/bash
# เปิดเดสก์ท็อป Ubuntu ในเบราว์เซอร์ (noVNC) ที่พอร์ต 6080 — รันทุกครั้งที่ codespace เริ่ม
#
# 🔴 ทำไมไม่ปล่อยให้ image เปิดเองที่พอร์ต 80
#    image นี้รัน noVNC เป็นผู้ใช้ทั่วไป (ubuntu) ที่พอร์ต 80
#    เครื่องที่ไม่อนุญาตให้ผู้ใช้ทั่วไปเปิดพอร์ตต่ำกว่า 1024 (เช่น Codespaces) → noVNC ล้มวนซ้ำ → เปิดหน้าเดสก์ท็อปได้ HTTP 502
#    Docker บน Mac อนุญาต จึงไม่เจอตอนทดสอบในเครื่อง
PORT=6080
if curl -s -o /dev/null "http://127.0.0.1:$PORT/"; then echo "เดสก์ท็อปเปิดอยู่แล้ว (พอร์ต $PORT)"; exit 0; fi

# ใช้ตัวเริ่มของ image เอง (สร้างผู้ใช้ ubuntu · ตั้ง VNC · เดสก์ท็อป) แต่เปลี่ยนพอร์ต noVNC เป็น 6080
sed -e "s#websockify --web=/usr/lib/novnc 80 #websockify --web=/usr/lib/novnc $PORT #" \
    -e 's#^exec /bin/tini -- supervisord#exec supervisord#' /entrypoint.sh > /tmp/r2h-entrypoint.sh
USER=ubuntu PASSWORD=ubuntu nohup setsid bash /tmp/r2h-entrypoint.sh > /tmp/r2h-desktop.log 2>&1 < /dev/null &

for i in $(seq 60); do curl -s -o /dev/null "http://127.0.0.1:$PORT/" && break; sleep 1; done
if ! curl -s -o /dev/null "http://127.0.0.1:$PORT/"; then
  echo "🔴 เดสก์ท็อปเปิดไม่ขึ้น — ดู /tmp/r2h-desktop.log"; tail -20 /tmp/r2h-desktop.log; exit 1
fi

# ค่าสำหรับ lab + ไฟล์เริ่มที่นี่บนเดสก์ท็อป (ผู้ใช้ ubuntu ถูกสร้างโดยตัวเริ่มข้างบน)
B=/home/ubuntu/.bashrc
grep -q ROS_DOMAIN_ID "$B" 2>/dev/null || printf '\n# ROS2 Hero\nexport ROS_DOMAIN_ID=30\n' >> "$B"
cp -n "$(dirname "$0")"/../labs/*.txt /home/ubuntu/Desktop/ 2>/dev/null || true
chown -R ubuntu:ubuntu /home/ubuntu/Desktop "$B" 2>/dev/null || true
echo "✅ เดสก์ท็อปพร้อม — แท็บ Ports → พอร์ต $PORT → รูปลูกโลก → Connect"
