#!/usr/bin/env bash
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"

run_from_file() {
  while true; do
    echo "=== CHẾ ĐỘ ĐỌC FILE ==="
    read -rp "Nhập đường dẫn file (hoặc nhấn 0 để quay lại): " path
    [[ $path == "0" ]] && return
    [[ ! -f $path ]] && echo "Không tìm thấy file!" && continue

    echo "Đang xử lý yêu cầu trong file..."
    while IFS= read -r line; do
      case "$line" in
        TaoNguoiDung:*)
          users=$(echo "$line" | cut -d: -f2 | tr -d ' ')
          IFS=',' read -ra arr <<< "$users"
          for u in "${arr[@]}"; do
            if user_exists "$u"; then echo "Người dùng $u đã tồn tại."; else useradd -m -s /bin/bash "$u" && echo "Đã tạo người dùng $u"; fi
          done
          ;;
        TaoNhom:*)
          groups=$(echo "$line" | cut -d: -f2 | tr -d ' ')
          IFS=',' read -ra arr <<< "$groups"
          for g in "${arr[@]}"; do
            if group_exists "$g"; then echo "Nhóm $g đã tồn tại."; else groupadd "$g" && echo "Đã tạo nhóm $g"; fi
          done
          ;;
        ThemNguoiVaoNhom:*)
          pairs=$(echo "$line" | cut -d: -f2)
          IFS=';' read -ra pr <<< "$pairs"
          for p in "${pr[@]}"; do
            user=$(echo "$p" | cut -d',' -f1 | tr -d ' ')
            group=$(echo "$p" | cut -d',' -f2 | tr -d ' ')
            usermod -aG "$group" "$user" && echo "Đã thêm $user vào $group"
          done
          ;;
        KhoaNguoiDung:*)
          users=$(echo "$line" | cut -d: -f2 | tr -d ' ')
          IFS=',' read -ra arr <<< "$users"
          for u in "${arr[@]}"; do
            usermod -L "$u" && echo "Đã khóa $u"
          done
          ;;
        MoKhoaNguoiDung:*)
          users=$(echo "$line" | cut -d: -f2 | tr -d ' ')
          IFS=',' read -ra arr <<< "$users"
          for u in "${arr[@]}"; do
            usermod -U "$u" && echo "Đã mở khóa $u"
          done
          ;;
      esac
    done < "$path"

    echo "✅ Hoàn tất xử lý file."
    echo "Nhấn 0 để quay lại hoặc Enter để nhập file khác."
    read -r back
    [[ $back == "0" ]] && return
  done
}
