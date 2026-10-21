#!/bin/bash
# ลงหุ่นจำลอง TurtleBot3 + Nav2 — รันครั้งเดียวตอนสร้างเครื่อง
set -e
export DEBIAN_FRONTEND=noninteractive
echo "▶ ลง TurtleBot3 + Nav2 + ฟอนต์ไทย (ครั้งแรกราว 1–4 นาที)"
apt-get update -qq
apt-get install -y -qq ros-jazzy-navigation2 ros-jazzy-nav2-bringup \
  ros-jazzy-nav2-minimal-tb3-sim ros-jazzy-turtlebot3-teleop ros-jazzy-ros-gz \
  fonts-thai-tlwg >/dev/null   # ฟอนต์ไทยแบบความกว้างเท่ากัน — ไม่มีแล้วภาษาไทยในเทอร์มินัลเป็นกล่องสี่เหลี่ยม
# ปิดพักหน้าจอ — ไม่งั้นทิ้ง lab ไว้สักพักจอดำ ผู้เรียนนึกว่าเครื่องค้าง
# (ตั้งเป็นค่าเริ่มต้นของเครื่อง: ไม่เปิดเองตอนไม่ได้ใช้ · ไม่ล็อก)
cat > /usr/share/glib-2.0/schemas/99_ros2hero.gschema.override <<'OVR'
[org.mate.screensaver]
idle-activation-enabled=false
lock-enabled=false
OVR
glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "✅ ลงเสร็จ"
