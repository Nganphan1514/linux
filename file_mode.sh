#!/usr/bin/env bash
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"
. "$(dirname "$0")/utils.sh"

# ============================================
# Chế độ đọc file yêu cầu
# ============================================
run_from_file() {
  while true; do
    echo "${blue}=== CHẾ ĐỘ ĐỌC FILE ===${reset}"
    echo "Nhập đường dẫn file chứa yêu cầu (hoặc nhấn ${yellow}0${reset} để quay lại):"
    read -rp "→ " path
    [[ $path == "0" ]] && return
    [[ ! -f $path ]] && echo "${red}❌ Không tìm thấy file: $path${reset}" && continue

    echo "${blue}Đang xử lý yêu cầu trong file...${reset}"
    echo "------------------------------------"

    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "$line" ]] && continue  # bỏ dòng trống
      cmd=$(echo "$line" | cut -d: -f1 | tr -d ' ')
      data=$(echo "$line" | cut -d: -f2- | tr -d ' ')

      case "$cmd" in
        TaoNguoiDung)
          IFS=',' read -ra users <<< "$data"
          for u in "${users[@]}"; do
            if user_exists "$u"; then
              echo "${yellow}⚠ Người dùng '$u' đã tồn tại.${reset}"
              log_action WARN "Người dùng '$u' đã tồn tại (bỏ qua)."
            else
              useradd -m -s /bin/bash "$u" && echo "${green}✅ Đã tạo người dùng: $u${reset}"
              log_action INFO "Đã tạo người dùng '$u'"
            fi
          done
          ;;
        TaoNhom)
          IFS=',' read -ra groups <<< "$data"
          for g in "${groups[@]}"; do
            if group_exists "$g"; then
              echo "${yellow}⚠ Nhóm '$g' đã tồn tại.${reset}"
              log_action WARN "Nhóm '$g' đã tồn tại (bỏ qua)."
            else
              groupadd "$g" && echo "${green}✅ Đã tạo nhóm: $g${reset}"
              log_action INFO "Đã tạo nhóm '$g'"
            fi
          done
          ;;
        ThemNguoiVaoNhom)
          IFS=';' read -ra pairs <<< "$data"
          for p in "${pairs[@]}"; do
            user=$(echo "$p" | cut -d',' -f1 | tr -d ' ')
            group=$(echo "$p" | cut -d',' -f2 | tr -d ' ')
            if ! user_exists "$user"; then
              echo "${red}❌ Người dùng '$user' không tồn tại.${reset}"
              log_action ERROR "Không thể thêm '$user' vào '$group' (user không tồn tại)."
              continue
            fi
            if ! group_exists "$group"; then
              echo "${red}❌ Nhóm '$group' không tồn tại.${reset}"
              log_action ERROR "Không thể thêm '$user' vào '$group' (nhóm không tồn tại)."
              continue
            fi
            usermod -aG "$group" "$user" && echo "${green}➕ Đã thêm $user vào nhóm $group${reset}"
            log_action INFO "Đã thêm '$user' vào nhóm '$group'"
          done
          ;;
        KhoaNguoiDung)
          IFS=',' read -ra users <<< "$data"
          for u in "${users[@]}"; do
            if user_exists "$u"; then
              usermod -L "$u" && echo "${yellow}🔒 Đã khóa người dùng: $u${reset}"
              log_action INFO "Đã khóa người dùng '$u'"
            else
              echo "${red}❌ Người dùng '$u' không tồn tại.${reset}"
              log_action ERROR "Không thể khóa '$u' (user không tồn tại)"
            fi
          done
          ;;
        MoKhoaNguoiDung)
          IFS=',' read -ra users <<< "$data"
          for u in "${users[@]}"; do
            if user_exists "$u"; then
              usermod -U "$u" && echo "${green}🔓 Đã mở khóa người dùng: $u${reset}"
              log_action INFO "Đã mở khóa người dùng '$u'"
            else
              echo "${red}❌ Người dùng '$u' không tồn tại.${reset}"
              log_action ERROR "Không thể mở khóa '$u' (user không tồn tại)"
            fi
          done
          ;;
        *)
          echo "${yellow}⚠ Dòng không hợp lệ hoặc không hỗ trợ: $line${reset}"
          log_action WARN "Bỏ qua dòng không hợp lệ: $line"
          ;;
      esac
    done < "$path"

    echo "------------------------------------"
    echo "${green}✅ Hoàn tất xử lý file: $path${reset}"
    echo "${blue}Nhấn 0 để quay lại hoặc Enter để nhập file khác.${reset}"
    read -r back
    [[ $back == "0" ]] && return
  done
}
