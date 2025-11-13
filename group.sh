#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

tao_nhom() {
  read -rp "Nhập tên nhóm: " group
  if [[ -z "$group" ]]; then echo "${red}Tên nhóm không được để trống.${reset}"; return; fi
  if ! valid_groupname "$group"; then echo "${red}Tên nhóm không hợp lệ.${reset}"; return; fi
  if group_exists "$group"; then echo "${yellow}Nhóm đã tồn tại.${reset}"; log_action WARN "Tạo nhóm thất bại: $group tồn tại"; return; fi
  safe_run groupadd "$group" && echo "${green}Đã tạo nhóm '$group'.${reset}" && log_action INFO "Tạo nhóm '$group'"
}

xoa_nhom() {
  read -rp "Nhập tên nhóm cần xóa: " group
  if [[ -z "$group" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! group_exists "$group"; then echo "${red}Không tồn tại nhóm.${reset}"; return; fi
  read -rp "Xác nhận xóa nhóm '$group'? (y/N): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    safe_run groupdel "$group" && echo "${green}Đã xóa nhóm '$group'.${reset}" && log_action INFO "Xóa nhóm '$group'"
  else
    echo "${yellow}Hủy xóa nhóm.${reset}"
  fi
}

them_nguoi_vao_nhom() {
  read -rp "Nhập tên người dùng: " user
  read -rp "Nhập tên nhóm: " group
  if [[ -z "$user" || -z "$group" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$user"; then echo "${red}Người dùng không tồn tại.${reset}"; return; fi
  if ! group_exists "$group"; then echo "${red}Nhóm không tồn tại.${reset}"; return; fi
  safe_run usermod -aG "$group" "$user" && echo "${green}Đã thêm '$user' vào nhóm '$group'.${reset}" && log_action INFO "Thêm '$user' vào nhóm '$group'"
}

xoa_nguoi_khoi_nhom() {
  read -rp "Nhập tên người dùng: " user
  read -rp "Nhập tên nhóm: " group
  if [[ -z "$user" || -z "$group" ]]; then echo "${red}Không được để trống.${reset}"; return; fi
  if ! user_exists "$user" || ! group_exists "$group"; then echo "${red}User hoặc group không tồn tại.${reset}"; return; fi
  safe_run gpasswd -d "$user" "$group" && echo "${green}Đã xóa '$user' khỏi nhóm '$group'.${reset}" && log_action INFO "Xóa '$user' khỏi nhóm '$group'"
}

danh_sach_nhom() {
  echo "${blue}--- Danh sách nhóm ---${reset}"
  cut -d: -f1 /etc/group
  log_action INFO "Liệt kê danh sách nhóm"
}
# -----------------------------
# MENU NHÓM
# -----------------------------
menu_group() {
  while true; do
    echo "${blue}=========== MENU NHÓM ===========${reset}"
    echo "1) Tạo nhóm"
    echo "2) Xóa nhóm"
    echo "3) Thêm người dùng vào nhóm"
    echo "4) Xóa người dùng khỏi nhóm"
    echo "5) Danh sách nhóm"
    echo "6) Quay lại menu chính"
    echo "================================="
    read -rp "Chọn (1-6): " c
    case $c in
      1) tao_nhom ;;
      2) xoa_nhom ;;
      3) them_nguoi_vao_nhom ;;
      4) xoa_nguoi_khoi_nhom ;;
      5) danh_sach_nhom ;;
      6) break ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}
