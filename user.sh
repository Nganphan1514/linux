#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

tao_nguoi_dung() {
  read -rp "Nhập tên người dùng: " username
  if [[ -z "$username" ]]; then
    echo "${red}Tên người dùng không được để trống.${reset}"; return
  fi
  if ! valid_username "$username"; then
    echo "${red}Tên không hợp lệ. Chỉ dùng a-z, 0-9, '_' hoặc '-' và bắt đầu bằng chữ thường hoặc '_'${reset}"
    return
  fi
  if user_exists "$username"; then
    echo "${yellow}Người dùng đã tồn tại.${reset}"
    log_action WARN "Tạo user thất bại: $username đã tồn tại"
    return
  fi

  safe_run useradd -m -s /bin/bash "$username" || { echo "${red}Tạo user thất bại.${reset}"; return; }
  echo "Đặt mật khẩu cho $username:"
  passwd "$username"
  chage -d 0 "$username" 2>/dev/null || true
  chage -M 90 "$username" 2>/dev/null || true
  echo "${green}Đã tạo người dùng '$username'.${reset}"
  log_action INFO "Tạo người dùng '$username'"
}

xoa_nguoi_dung() {
  read -rp "Nhập tên người dùng cần xóa: " username
  if [[ -z "$username" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$username"; then
    echo "${red}Không tìm thấy người dùng.${reset}"; log_action WARN "Xóa user thất bại: $username không tồn tại"; return
  fi
  read -rp "Xác nhận xóa '$username' và thư mục home? (y/N): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    safe_run userdel -r "$username" && echo "${green}Đã xóa người dùng '$username'.${reset}" && log_action INFO "Xóa người dùng '$username'"
  else
    echo "${yellow}Hủy xóa.${reset}"
  fi
}

doi_mat_khau() {
  read -rp "Nhập tên người dùng: " username
  if [[ -z "$username" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$username"; then echo "${red}Không tồn tại.${reset}"; return; fi
  passwd "$username"
  echo "${green}Đổi mật khẩu thành công cho '$username'.${reset}"
  log_action INFO "Đổi mật khẩu cho '$username'"
}

thong_tin_nguoi_dung() {
  read -rp "Nhập tên người dùng: " username
  if [[ -z "$username" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$username"; then echo "${red}Không tồn tại.${reset}"; return; fi
  echo "${blue}--- Thông tin người dùng '$username' ---${reset}"
  id "$username"
  chage -l "$username"
  log_action INFO "Xem thông tin người dùng '$username'"
}

danh_sach_nguoi_dung() {
  echo "${blue}--- Danh sách người dùng ---${reset}"
  cut -d: -f1 /etc/passwd
  log_action INFO "Liệt kê danh sách người dùng"
}

dang_dang_nhap() {
  echo "${blue}--- Người dùng đang đăng nhập ---${reset}"
  who
  log_action INFO "Xem người dùng đang đăng nhập"
}

lich_su_dang_nhap() {
  read -rp "Nhập tên người dùng: " username
  if [[ -z "$username" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  last "$username" | head
  log_action INFO "Xem lịch sử đăng nhập của '$username'"
}
menu_user() {
  while true; do
    echo "${blue}--- MENU NGƯỜI DÙNG ---${reset}"
    echo "1) Tạo người dùng"
    echo "2) Xóa người dùng"
    echo "3) Đổi mật khẩu"
    echo "4) Xem thông tin"
    echo "5) Danh sách người dùng"
    echo "6) Người dùng đang đăng nhập"
    echo "7) Lịch sử đăng nhập"
    echo "8) Quay lại"
    read -rp "Chọn (1-8): " c
    case $c in
      1) tao_nguoi_dung ;;
      2) xoa_nguoi_dung ;;
      3) doi_mat_khau ;;
      4) thong_tin_nguoi_dung ;;
      5) danh_sach_nguoi_dung ;;
      6) dang_dang_nhap ;;
      7) lich_su_dang_nhap ;;
      8) return ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

