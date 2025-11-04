#!/usr/bin/env bash
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"
. "$(dirname "$0")/utils.sh"

# ====== HÀM XUẤT FILE ======
xuat_file() {
  while true; do
    echo "${bold}${blue}--- MENU XUẤT FILE ---${reset}"
    echo "1) Xuất danh sách người dùng"
    echo "2) Xuất danh sách nhóm"
    echo "3) Xuất toàn bộ (người dùng + nhóm + người trong nhóm)"
    echo "4) Xuất log"
    echo "5) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1)
        out="export_users_$(date +%Y%m%d_%H%M%S).txt"
        cut -d: -f1 /etc/passwd > "$out"
        echo "${green}Đã xuất danh sách người dùng vào $out${reset}"
        log_action INFO "Xuất danh sách người dùng -> $out"
        ;;
      2)
        out="export_groups_$(date +%Y%m%d_%H%M%S).txt"
        cut -d: -f1 /etc/group > "$out"
        echo "${green}Đã xuất danh sách nhóm vào $out${reset}"
        log_action INFO "Xuất danh sách nhóm -> $out"
        ;;
      3)
        out="export_all_$(date +%Y%m%d_%H%M%S).txt"
        echo "=== DANH SÁCH NGƯỜI DÙNG ===" > "$out"
        cut -d: -f1 /etc/passwd >> "$out"
        echo -e "\n=== DANH SÁCH NHÓM ===" >> "$out"
        cut -d: -f1 /etc/group >> "$out"
        echo -e "\n=== THÀNH VIÊN TRONG NHÓM ===" >> "$out"
        while IFS=: read -r name pass gid members; do
          [ -n "$members" ] && echo "$name: $members" >> "$out"
        done < /etc/group
        echo "${green}Đã xuất toàn bộ dữ liệu vào $out${reset}"
        log_action INFO "Xuất toàn bộ -> $out"
        ;;
      4)
        menu_xuat_log
        ;;
      5) return ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

menu_xuat_log() {
  while true; do
    echo "${bold}${blue}--- XUẤT LOG ---${reset}"
    echo "1) Xuất log theo người dùng"
    echo "2) Xuất log theo nhóm"
    echo "3) Xuất toàn bộ log"
    echo "4) Quay lại"
    read -rp "Chọn: " lc
    case $lc in
      1)
        read -rp "Nhập tên người dùng: " u
        grep "$u" "$LOG_FILE" > "log_user_${u}_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}Đã xuất log của '$u'.${reset}"
        ;;
      2)
        read -rp "Nhập tên nhóm: " g
        grep "$g" "$LOG_FILE" > "log_group_${g}_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}Đã xuất log của nhóm '$g'.${reset}"
        ;;
      3)
        cp "$LOG_FILE" "log_all_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}Đã xuất toàn bộ log.${reset}"
        ;;
      4) return ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

# ====== MENU CHÍNH ======
main_menu() {
  while true; do
    echo "${bold}${blue}=== MENU CHÍNH ===${reset}"
    echo "1) Đọc yêu cầu từ file"
    echo "2) Thực hiện thao tác trực tiếp"
    echo "3) Xuất file"
    echo "4) Thoát"
    read -rp "Chọn: " c
    case $c in
      1) thuc_hien_tu_file ;;
      2) menu_truc_tiep ;;
      3) xuat_file ;;
      4) echo "${yellow}Tạm biệt!${reset}"; exit 0 ;;
      *) echo "${red}Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

# ====== ĐỌC FILE YÊU CẦU ======
thuc_hien_tu_file() {
  read -rp "Nhập đường dẫn file (hoặc 0 để quay lại): " path
  [ "$path" = "0" ] && return
  if [ ! -f "$path" ]; then
    echo "${red}Không tìm thấy file!${reset}"
    log_action ERROR "Không tìm thấy file yêu cầu: $path"
    return
  fi

  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    cmd=$(echo "$line" | cut -d: -f1 | tr -d ' ')
    args=$(echo "$line" | cut -d: -f2- | tr -d ' ')
    case "$cmd" in
      TaoNguoiDung) for u in ${args//,/ }; do useradd -m "$u"; log_action INFO "Tạo người dùng '$u'"; done ;;
      TaoNhom) for g in ${args//,/ }; do groupadd "$g"; log_action INFO "Tạo nhóm '$g'"; done ;;
      ThemNguoiVaoNhom)
        IFS=';' read -ra pairs <<< "$args"
        for p in "${pairs[@]}"; do
          u=$(echo "$p" | cut -d',' -f1)
          g=$(echo "$p" | cut -d',' -f2)
          usermod -aG "$g" "$u"
          log_action INFO "Thêm '$u' vào nhóm '$g'"
        done ;;
      *) echo "${yellow}Bỏ qua dòng: $line${reset}" ;;
    esac
  done < "$path"

  echo "${green}Hoàn thành xử lý file yêu cầu.${reset}"
}

# ====== MENU TRỰC TIẾP ======
menu_truc_tiep() {
  while true; do
    echo "${bold}${blue}--- MENU TRỰC TIẾP ---${reset}"
    echo "1) Quản lý người dùng"
    echo "2) Quản lý nhóm"
    echo "3) Bảo mật"
    echo "4) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) menu_user ;;
      2) menu_group ;;
      3) menu_security ;;
      4) return ;;
    esac
  done
}

menu_user() {
  while true; do
    echo "${bold}--- NGƯỜI DÙNG ---${reset}"
    echo "1) Tạo người dùng"
    echo "2) Xóa người dùng"
    echo "3) Đổi mật khẩu"
    echo "4) Xem thông tin"
    echo "5) Liệt kê người dùng"
    echo "6) Ai đang đăng nhập"
    echo "7) Lịch sử đăng nhập"
    echo "8) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) tao_nguoi_dung ;;
      2) xoa_nguoi_dung ;;
      3) doi_mat_khau ;;
      4) thong_tin_nguoi_dung ;;
      5) danh_sach_nguoi_dung ;;
      6) dang_dang_nhap ;;
      7) lich_su_dang_nhap ;;
      8) return ;;
    esac
  done
}

menu_group() {
  while true; do
    echo "${bold}--- NHÓM ---${reset}"
    echo "1) Tạo nhóm"
    echo "2) Xóa nhóm"
    echo "3) Thêm người vào nhóm"
    echo "4) Xóa người khỏi nhóm"
    echo "5) Liệt kê nhóm"
    echo "6) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) tao_nhom ;;
      2) xoa_nhom ;;
      3) them_nguoi_vao_nhom ;;
      4) xoa_nguoi_khoi_nhom ;;
      5) danh_sach_nhom ;;
      6) return ;;
    esac
  done
}

menu_security() {
  while true; do
    echo "${bold}--- BẢO MẬT ---${reset}"
    echo "1) Khóa tài khoản"
    echo "2) Mở khóa tài khoản"
    echo "3) Áp dụng chính sách mật khẩu"
    echo "4) Quay lại"
    read -rp "Chọn: " c
    case $c in
      1) khoa_nguoi_dung ;;
      2) mo_khoa_nguoi_dung ;;
      3) chinh_sach_mat_khau ;;
      4) return ;;
    esac
  done
}

# Chạy menu chính
main_menu
