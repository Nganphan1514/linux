#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

khoa_nguoi_dung() {
  read -rp "Nhập tên người dùng cần khóa: " user
  if [[ -z "$user" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$user"; then echo "${red}Không tồn tại người dùng.${reset}"; return; fi
  safe_run passwd -l "$user" && echo "${yellow}Đã khóa tài khoản '$user'.${reset}" && log_action INFO "Khóa tài khoản '$user'"
}

mo_khoa_nguoi_dung() {
  read -rp "Nhập tên người dùng cần mở khóa: " user
  if [[ -z "$user" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$user"; then echo "${red}Không tồn tại người dùng.${reset}"; return; fi
  safe_run passwd -u "$user" && echo "${green}Đã mở khóa tài khoản '$user'.${reset}" && log_action INFO "Mở khóa tài khoản '$user'"
}

chinh_sach_mat_khau() {
  read -rp "Nhập tên người dùng: " user
  if [[ -z "$user" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$user"; then echo "${red}Không tồn tại người dùng.${reset}"; return; fi
  safe_run chage -d 0 "$user"
  safe_run chage -M 90 "$user"
  echo "${blue}Áp dụng chính sách mật khẩu (90 ngày) cho '$user'.${reset}"
  log_action INFO "Áp dụng chính sách mật khẩu cho '$user'"
}
