#!/usr/bin/env bash
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"
. "$(dirname "$0")/file_mode.sh"

# ======== MENU CHÍNH ========
main_menu() {
  while true; do
    echo "====== QUẢN LÝ NGƯỜI DÙNG & NHÓM ======"
    echo "1) Đọc yêu cầu từ file"
    echo "2) Thực hiện thao tác trực tiếp"
    echo "3) Xuất file log"
    echo "4) Thoát"
    read -rp "Chọn (1-4): " c
    case $c in
      1) run_from_file ;;
      2) direct_mode ;;
      3) export_logs ;;
      4) echo "Tạm biệt!"; exit 0 ;;
      *) echo "Lựa chọn không hợp lệ!" ;;
    esac
  done
}

# ======== CHẾ ĐỘ TRỰC TIẾP ========
direct_mode() {
  while true; do
    echo "=== MENU CHÍNH ==="
    echo "1) Quản lý người dùng"
    echo "2) Quản lý nhóm"
    echo "3) Bảo mật tài khoản"
    echo "4) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) user_menu ;;
      2) group_menu ;;
      3) security_menu ;;
      4) return ;;
    esac
  done
}

# ======== MENU NGƯỜI DÙNG ========
user_menu() {
  while true; do
    echo "--- QUẢN LÝ NGƯỜI DÙNG ---"
    echo "1) Tạo người dùng"
    echo "2) Xóa người dùng"
    echo "3) Đổi mật khẩu"
    echo "4) Hiển thị thông tin"
    echo "5) Liệt kê tất cả người dùng"
    echo "6) Ai đang đăng nhập"
    echo "7) Lịch sử đăng nhập"
    echo "8) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) create_user ;;
      2) delete_user ;;
      3) change_password ;;
      4) show_user_info ;;
      5) list_all_users ;;
      6) who_is_logged_in ;;
      7) last_logins_for_user ;;
      8) return ;;
    esac
  done
}

# ======== MENU NHÓM ========
group_menu() {
  while true; do
    echo "--- QUẢN LÝ NHÓM ---"
    echo "1) Tạo nhóm"
    echo "2) Xóa nhóm"
    echo "3) Thêm người dùng vào nhóm"
    echo "4) Xóa người khỏi nhóm"
    echo "5) Liệt kê nhóm"
    echo "6) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) create_group ;;
      2) delete_group ;;
      3) add_user_to_group ;;
      4) remove_user_from_group ;;
      5) list_all_groups ;;
      6) return ;;
    esac
  done
}

# ======== MENU BẢO MẬT ========
security_menu() {
  while true; do
    echo "--- BẢO MẬT TÀI KHOẢN ---"
    echo "1) Khóa tài khoản"
    echo "2) Mở khóa tài khoản"
    echo "3) Áp dụng chính sách mật khẩu"
    echo "4) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) lock_user ;;
      2) unlock_user ;;
      3) apply_password_policy ;;
      4) return ;;
    esac
  done
}

# ======== XUẤT FILE LOG ========
export_logs() {
  echo "1) Xuất toàn bộ log"
  echo "2) Lọc log theo loại (INFO, ERROR...)"
  read -rp "Chọn: " opt
  if [[ $opt == 1 ]]; then
    cp /var/log/user_group_manager.log ./log_export.txt
    echo "Đã xuất log ra file log_export.txt"
  elif [[ $opt == 2 ]]; then
    read -rp "Nhập loại log (ví dụ: INFO): " lvl
    grep "\[$lvl\]" /var/log/user_group_manager.log > ./log_$lvl.txt
    echo "Đã xuất log loại $lvl ra file log_$lvl.txt"
  fi
}

main_menu
