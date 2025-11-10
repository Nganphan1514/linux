#!/usr/bin/env bash
# uninstall.sh – Dọn dẹp môi trường dự án

if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Vui lòng chạy bằng quyền root (sudo ./uninstall.sh)"
  exit 1
fi

echo "🧹 Đang dọn dẹp..."

rm -rf logs exports
echo "🗑️ Đã xóa thư mục logs và exports"

TEST_USERS=("test1" "demo" "userdemo")
TEST_GROUPS=("stafftest" "groupdemo")

for u in "${TEST_USERS[@]}"; do
  if id "$u" &>/dev/null; then
    userdel -r "$u"
    echo "❌ Đã xóa người dùng test: $u"
  fi
done

for g in "${TEST_GROUPS[@]}"; do
  if getent group "$g" &>/dev/null; then
    groupdel "$g"
    echo "❌ Đã xóa nhóm test: $g"
  fi
done

echo "✅ Hoàn tất gỡ cài đặt."
