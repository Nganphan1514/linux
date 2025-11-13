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
# -----------------------------
# MENU BẢO MẬT
# -----------------------------
menu_security() {
  while true; do
    echo "${blue}=========== MENU BẢO MẬT ===========${reset}"
    echo "1) Khóa tài khoản người dùng"
    echo "2) Mở khóa tài khoản người dùng"
    echo "3) Kiểm tra chính sách mật khẩu"
    echo "4) Quay lại menu chính"
    echo "===================================="
    read -rp "Chọn (1-4): " c
    case $c in
      1) khoa_nguoi_dung ;;
      2) mo_khoa_nguoi_dung ;;
      3) chinh_sach_mat_khau ;;
      4) break ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}
