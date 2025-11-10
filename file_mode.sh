#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"

# Thực thi các lệnh từ file. Mẫu file: "Lenh: data"
# Các lệnh hỗ trợ: TaoNguoiDung, XoaNguoiDung, DoiMatKhau, ThongTinNguoiDung, DanhSachNguoiDung,
# TaoNhom, XoaNhom, ThemNguoiVaoNhom, XoaNguoiKhoiNhom, DanhSachNhom,
# KhoaNguoiDung, MoKhoaNguoiDung, ChinhSachMatKhau

run_from_file() {
  local input_file="$1"
  if [[ -z "$input_file" ]]; then
    read -rp "Nhập đường dẫn file chứa yêu cầu (hoặc 0 để quay lại): " input_file
    [[ "$input_file" == "0" ]] && return
  fi

  if [[ ! -f "$input_file" ]]; then
    echo "${red}Không tìm thấy file: $input_file${reset}"
    log_action ERROR "Không tìm thấy file yêu cầu: $input_file"
    return 1
  fi

  echo "${blue}Đang xử lý file: $input_file${reset}"
  echo "------------------------------------"

  while IFS= read -r line || [[ -n "$line" ]]; do
    # loại bỏ khoảng trắng ở đầu/đuôi
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    cmd=$(echo "$line" | cut -d: -f1 | tr -d ' ')
    data=$(echo "$line" | cut -d: -f2-)
    # trim data
    data="${data#"${data%%[![:space:]]*}"}"
    data="${data%"${data##*[![:space:]]}"}"

    case "$cmd" in
      TaoNguoiDung)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if [[ -z "$u" ]]; then continue; fi
          if ! valid_username "$u"; then
            echo "${red}Tên user '$u' không hợp lệ - bỏ qua.${reset}"
            log_action WARN "Tên user không hợp lệ: $u"
            continue
          fi
          if user_exists "$u"; then echo "${yellow}Người dùng '$u' đã tồn tại - bỏ qua.${reset}"; log_action WARN "TaoNguoiDung: $u tồn tại"; else
            safe_run useradd -m -s /bin/bash "$u" && echo "${green}Đã tạo: $u${reset}" && log_action INFO "TaoNguoiDung: $u"
          fi
        done
        ;;
      XoaNguoiDung)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if [[ -z "$u" ]]; then continue; fi
          if user_exists "$u"; then
            safe_run userdel -r "$u" && echo "${green}Đã xóa: $u${reset}" && log_action INFO "XoaNguoiDung: $u"
          else
            echo "${yellow}Người dùng '$u' không tồn tại - bỏ qua.${reset}"
            log_action WARN "XoaNguoiDung: $u không tồn tại"
          fi
        done
        ;;
      DoiMatKhau)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if user_exists "$u"; then
            echo "Đổi mật khẩu cho $u (nhập mật khẩu theo prompt)..."
            passwd "$u"
            log_action INFO "DoiMatKhau: $u"
          else
            echo "${yellow}Không tồn tại: $u - bỏ qua.${reset}"
            log_action WARN "DoiMatKhau: $u không tồn tại"
          fi
        done
        ;;
      ThongTinNguoiDung)
        if [[ -z "$data" ]]; then echo "${red}Thiếu tên người dùng.${reset}"; continue; fi
        if user_exists "$data"; then
          id "$data"; chage -l "$data"
          log_action INFO "ThongTinNguoiDung: $data"
        else
          echo "${yellow}Không tồn tại: $data${reset}"
          log_action WARN "ThongTinNguoiDung: $data không tồn tại"
        fi
        ;;
      DanhSachNguoiDung)
        cut -d: -f1 /etc/passwd
        log_action INFO "DanhSachNguoiDung"
        ;;
      TaoNhom)
        IFS=',' read -ra groups <<< "$data"
        for g in "${groups[@]}"; do
          g="$(echo "$g" | tr -d ' ')"
          if ! valid_groupname "$g"; then echo "${red}Tên nhóm không hợp lệ: $g - bỏ qua${reset}"; log_action WARN "Tên nhóm không hợp lệ: $g"; continue; fi
          if group_exists "$g"; then echo "${yellow}Nhóm '$g' đã tồn tại - bỏ qua.${reset}"; else
            safe_run groupadd "$g" && echo "${green}Đã tạo nhóm: $g${reset}" && log_action INFO "TaoNhom: $g"
          fi
        done
        ;;
      XoaNhom)
        IFS=',' read -ra groups <<< "$data"
        for g in "${groups[@]}"; do
          g="$(echo "$g" | tr -d ' ')"
          if group_exists "$g"; then safe_run groupdel "$g" && echo "${green}Đã xóa nhóm: $g${reset}" && log_action INFO "XoaNhom: $g"; else echo "${yellow}Nhóm '$g' không tồn tại - bỏ qua.${reset}"; fi
        done
        ;;
      ThemNguoiVaoNhom)
        IFS=';' read -ra pairs <<< "$data"
        for p in "${pairs[@]}"; do
          user=$(echo "$p" | cut -d',' -f1 | tr -d ' ')
          group=$(echo "$p" | cut -d',' -f2 | tr -d ' ')
          if [[ -z "$user" || -z "$group" ]]; then echo "${yellow}Cặp không hợp lệ: $p - bỏ qua${reset}"; continue; fi
          if user_exists "$user" && group_exists "$group"; then safe_run usermod -aG "$group" "$user" && echo "${green}Đã thêm $user vào $group${reset}" && log_action INFO "ThemNguoiVaoNhom: $user->$group"; else echo "${red}User hoặc group không tồn tại: $user, $group${reset}"; fi
        done
        ;;
      XoaNguoiKhoiNhom)
        IFS=';' read -ra pairs <<< "$data"
        for p in "${pairs[@]}"; do
          user=$(echo "$p" | cut -d',' -f1 | tr -d ' ')
          group=$(echo "$p" | cut -d',' -f2 | tr -d ' ')
          if user_exists "$user" && group_exists "$group"; then safe_run gpasswd -d "$user" "$group" && echo "${green}Đã xóa $user khỏi $group${reset}" && log_action INFO "XoaNguoiKhoiNhom: $user->$group"; else echo "${red}User hoặc group không tồn tại: $user, $group${reset}"; fi
        done
        ;;
      DanhSachNhom)
        cut -d: -f1 /etc/group
        log_action INFO "DanhSachNhom"
        ;;
      KhoaNguoiDung)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if user_exists "$u"; then passwd -l "$u" && echo "${yellow}Đã khóa: $u${reset}" && log_action INFO "KhoaNguoiDung: $u"; else echo "${yellow}Không tồn tại: $u${reset}"; fi
        done
        ;;
      MoKhoaNguoiDung)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if user_exists "$u"; then passwd -u "$u" && echo "${green}Đã mở khóa: $u${reset}" && log_action INFO "MoKhoaNguoiDung: $u"; else echo "${yellow}Không tồn tại: $u${reset}"; fi
        done
        ;;
      ChinhSachMatKhau)
        IFS=',' read -ra users <<< "$data"
        for u in "${users[@]}"; do
          u="$(echo "$u" | tr -d ' ')"
          if user_exists "$u"; then chage -d 0 "$u"; chage -M 90 "$u"; echo "${blue}Áp dụng chính sách mật khẩu cho $u${reset}"; log_action INFO "ChinhSachMatKhau: $u"; else echo "${yellow}Không tồn tại: $u${reset}"; fi
        done
        ;;
      *)
        echo "${yellow}Bỏ qua dòng: $line (lệnh không hỗ trợ)${reset}"
        log_action WARN "Dòng không hỗ trợ: $line"
        ;;
    esac
  done < "$input_file"

  echo "${green}Hoàn tất xử lý file yêu cầu.${reset}"
}
