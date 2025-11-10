#!/usr/bin/env bash
# =====================================
# main.sh – Quản lý người dùng & nhóm Linux
# =====================================

# ===== KIỂM TRA QUYỀN ROOT =====
if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Vui lòng chạy bằng quyền root (sudo ./main.sh)"
  exit 1
fi

# ===== NẠP CÁC MODULE =====
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"
. "$(dirname "$0")/utils.sh"
. "$(dirname "$0")/file_mode.sh"

# ====== HÀM XUẤT FILE ======
xuat_file() {
  while true; do
    echo "${bold}${blue}--- MENU XUẤT FILE ---${reset}"
    echo "1) Xuất danh sách người dùng"
    echo "2) Xuất danh sách nhóm"
    echo "3) Xuất toàn bộ (người dùng + nhóm + người trong nhóm)"
    echo "4) Xuất log"
    echo "5) Quay lại"
    read -rp "Chọn (1-5): " c
    case $c in
      1)
        out="exports/export_users_$(date +%Y%m%d_%H%M%S).txt"
        cut -d: -f1 /etc/passwd > "$out"
        echo "${green}✅ Đã xuất danh sách người dùng vào $out${reset}"
        log_action INFO "Xuất danh sách người dùng -> $out"
        ;;
      2)
        out="exports/export_groups_$(date +%Y%m%d_%H%M%S).txt"
        cut -d: -f1 /etc/group > "$out"
        echo "${green}✅ Đã xuất danh sách nhóm vào $out${reset}"
        log_action INFO "Xuất danh sách nhóm -> $out"
        ;;
      3)
        out="exports/export_all_$(date +%Y%m%d_%H%M%S).txt"
        {
          echo "=== DANH SÁCH NGƯỜI DÙNG ==="
          cut -d: -f1 /etc/passwd
          echo -e "\n=== DANH SÁCH NHÓM ==="
          cut -d: -f1 /etc/group
          echo -e "\n=== THÀNH VIÊN TRONG NHÓM ==="
          while IFS=: read -r name pass gid members; do
            [ -n "$members" ] && echo "$name: $members"
          done < /etc/group
        } > "$out"
        echo "${green}✅ Đã xuất toàn bộ dữ liệu vào $out${reset}"
        log_action INFO "Xuất toàn bộ -> $out"
        ;;
      4)
        menu_xuat_log
        ;;
      5) return ;;
      *) echo "${red}❌ Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

# ====== MENU XUẤT LOG ======
menu_xuat_log() {
  while true; do
    echo "${bold}${blue}--- XUẤT LOG ---${reset}"
    echo "1) Theo người dùng"
    echo "2) Theo nhóm"
    echo "3) Toàn bộ log"
    echo "4) Quay lại"
    read -rp "Chọn (1-4): " lc
    case $lc in
      1)
        read -rp "Nhập tên người dùng: " u
        [[ -z "$u" ]] && echo "${red}Tên không được để trống.${reset}" && continue
        grep -i "$u" "$LOG_FILE" > "exports/log_user_${u}_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}✅ Đã xuất log người dùng '$u'.${reset}"
        ;;
      2)
        read -rp "Nhập tên nhóm: " g
        [[ -z "$g" ]] && echo "${red}Tên không được để trống.${reset}" && continue
        grep -i "$g" "$LOG_FILE" > "exports/log_group_${g}_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}✅ Đã xuất log nhóm '$g'.${reset}"
        ;;
      3)
        cp "$LOG_FILE" "exports/log_all_$(date +%Y%m%d_%H%M%S).txt"
        echo "${green}✅ Đã xuất toàn bộ log.${reset}"
        ;;
      4) return ;;
      *) echo "${red}❌ Lựa chọn không hợp lệ.${reset}" ;;
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
    read -rp "Chọn (1-4): " c
    case $c in
      1) run_from_file ;;
      2) menu_truc_tiep ;;
      3) xuat_file ;;
      4) echo "${yellow}Tạm biệt!${reset}"; exit 0 ;;
      *) echo "${red}❌ Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

# ====== MENU TRỰC TIẾP ======
menu_truc_tiep() {
  while true; do
    echo "${bold}${blue}--- MENU TRỰC TIẾP ---${reset}"
    echo "1) Quản lý người dùng"
    echo "2) Quản lý nhóm"
    echo "3) Bảo mật"
    echo "4) Quay lại"
    read -rp "Chọn (1-4): " c
    case $c in
      1) menu_user ;;
      2) menu_group ;;
      3) menu_security ;;
      4) return ;;
      *) echo "${red}❌ Lựa chọn không hợp lệ.${reset}" ;;
    esac
  done
}

# ===== CHẠY MENU CHÍNH =====
main_menu
