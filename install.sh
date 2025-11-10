#!/usr/bin/env bash
# install.sh – Cài đặt môi trường dự án quản lý người dùng

if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Vui lòng chạy bằng quyền root (sudo ./install.sh)"
  exit 1
fi

echo "🔧 Đang thiết lập môi trường..."

mkdir -p logs exports
chmod 700 logs exports
chmod +x ./*.sh

for cmd in useradd groupadd usermod chage; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "⚠️ Thiếu lệnh hệ thống: $cmd"
  fi
done

echo "✅ Hoàn tất cài đặt! Chạy chương trình bằng: sudo ./main.sh"
