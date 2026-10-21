#!/bin/bash
# ลงหุ่นจำลอง TurtleBot3 + Nav2 แล้ววางแบบฝึกหัดบนเดสก์ท็อป — รันครั้งเดียวตอนสร้างเครื่อง
set -e
export DEBIAN_FRONTEND=noninteractive
echo "▶ ลง TurtleBot3 + Nav2 (ครั้งแรกราว 2–4 นาที)"
apt-get update -qq
apt-get install -y -qq ros-jazzy-navigation2 ros-jazzy-nav2-bringup \
  ros-jazzy-nav2-minimal-tb3-sim ros-jazzy-turtlebot3-teleop ros-jazzy-ros-gz >/dev/null

# ผู้ใช้เดสก์ท็อป (ubuntu) ถูกสร้างตอนเครื่องเริ่ม — รอให้มีก่อน
for i in $(seq 60); do [ -d /home/ubuntu/Desktop ] && break; sleep 2; done
B=/home/ubuntu/.bashrc
grep -q TURTLEBOT3_MODEL "$B" 2>/dev/null || printf '\n# ROS2 Hero\nexport TURTLEBOT3_MODEL=waffle\nexport ROS_DOMAIN_ID=30\n' >> "$B"
cp labs/step2/*.txt /home/ubuntu/Desktop/ 2>/dev/null || true
chown -R ubuntu:ubuntu /home/ubuntu/Desktop "$B" 2>/dev/null || true
echo "✅ พร้อมแล้ว — เปิดแท็บ 'เดสก์ท็อป ROS 2' (แท็บ PORTS → พอร์ต 80) แล้วกด Connect"
