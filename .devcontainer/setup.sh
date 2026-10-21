#!/bin/bash
# ลงหุ่นจำลอง TurtleBot3 + Nav2 — รันครั้งเดียวตอนสร้างเครื่อง
set -e
export DEBIAN_FRONTEND=noninteractive
echo "▶ ลง TurtleBot3 + Nav2 (ครั้งแรกราว 1–4 นาที)"
apt-get update -qq
apt-get install -y -qq ros-jazzy-navigation2 ros-jazzy-nav2-bringup \
  ros-jazzy-nav2-minimal-tb3-sim ros-jazzy-turtlebot3-teleop ros-jazzy-ros-gz >/dev/null
echo "✅ ลงเสร็จ"
