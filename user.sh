#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

tao_nguoi_dung() {
  read -rp "Nhập tên người dùng: " username
  if user_exists "$username"; then
    echo "${yellow}Người dùng đã tồn tại.${reset}"
    log_action WARN "Người dùng '$username' đã tồn tại"
    return
  fi
  useradd -m -s /bin/bash "$username"
  passwd "$username"
  chage -d 0 "$username"
  chage -M 90 "$username"
  echo "${green}Đã tạo người dùng '$username'.${reset}"
  log_action INFO "Tạo người dùng '$username'"
}

xoa_nguoi_dung() {
  read -rp "Nhập tên người dùng cần xóa: " username
  if ! user_exists "$username"; then
    echo "${red}Không tìm thấy người dùng.${reset}"
    log_action WARN "Không tìm thấy người dùng '$username'"
    return
  fi
  userdel -r "$username"
  echo "${green}Đã xóa người dùng '$username'.${reset}"
  log_action INFO "Xóa người dùng '$username'"
}

doi_mat_khau() {
  read -rp "Nhập tên người dùng: " username
  if ! user_exists "$username"; then echo "${red}Không tồn tại.${reset}"; return; fi
  passwd "$username"
  echo "${green}Đổi mật khẩu thành công cho '$username'.${reset}"
  log_action INFO "Đổi mật khẩu cho '$username'"
}

thong_tin_nguoi_dung() {
  read -rp "Nhập tên người dùng: " username
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
  last "$username" | head
  log_action INFO "Xem lịch sử đăng nhập của '$username'"
}
