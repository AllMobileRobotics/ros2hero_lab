#!/bin/bash
# เตรียมเครื่องครั้งเดียวตอนสร้าง — ROS 2 Jazzy + เครื่องมือหน้าจอ มากับ image แล้ว
set -e
export DEBIAN_FRONTEND=noninteractive
echo "▶ ลงฟอนต์ไทย (ครั้งแรกราว 1 นาที)"
apt-get update -qq
apt-get install -y -qq fonts-thai-tlwg >/dev/null   # ฟอนต์ไทยแบบความกว้างเท่ากัน — ไม่มีแล้วภาษาไทยในเทอร์มินัลเป็นกล่องสี่เหลี่ยม

# ปิดพักหน้าจอ — ไม่งั้นทิ้ง lab ไว้สักพักจอดำ ผู้เรียนนึกว่าเครื่องค้าง
# (ตั้งเป็นค่าเริ่มต้นของเครื่อง: ไม่เปิดเองตอนไม่ได้ใช้ · ไม่ล็อก)
cat > /usr/share/glib-2.0/schemas/99_ros2hero.gschema.override <<'OVR'
[org.mate.screensaver]
idle-activation-enabled=false
lock-enabled=false
OVR
glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "✅ ลงเสร็จ"
