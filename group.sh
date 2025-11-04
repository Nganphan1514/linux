#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

tao_nhom() {
  read -rp "Nhập tên nhóm: " group
  if group_exists "$group"; then
    echo "${yellow}Nhóm đã tồn tại.${reset}"
    log_action WARN "Nhóm '$group' đã tồn tại"
    return
  fi
  groupadd "$group"
  echo "${green}Đã tạo nhóm '$group'.${reset}"
  log_action INFO "Tạo nhóm '$group'"
}

xoa_nhom() {
  read -rp "Nhập tên nhóm cần xóa: " group
  groupdel "$group" && echo "${green}Đã xóa nhóm '$group'.${reset}"
  log_action INFO "Xóa nhóm '$group'"
}

them_nguoi_vao_nhom() {
  read -rp "Nhập tên người dùng: " user
  read -rp "Nhập tên nhóm: " group
  usermod -aG "$group" "$user"
  echo "${green}Đã thêm '$user' vào nhóm '$group'.${reset}"
  log_action INFO "Thêm '$user' vào nhóm '$group'"
}

xoa_nguoi_khoi_nhom() {
  read -rp "Nhập tên người dùng: " user
  read -rp "Nhập tên nhóm: " group
  gpasswd -d "$user" "$group"
  echo "${green}Đã xóa '$user' khỏi nhóm '$group'.${reset}"
  log_action INFO "Xóa '$user' khỏi nhóm '$group'"
}

danh_sach_nhom() {
  echo "${blue}--- Danh sách nhóm ---${reset}"
  cut -d: -f1 /etc/group
  log_action INFO "Liệt kê danh sách nhóm"
}
