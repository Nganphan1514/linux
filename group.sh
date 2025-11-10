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
