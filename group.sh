#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

# ====== TẠO NHÓM ======
create_group() {
  read -rp "Nhập tên nhóm mới: " g
  if group_exists "$g"; then
    notify_warn "Nhóm '$g' đã tồn tại."
    return
  fi
  groupadd "$g"
  notify_success "Đã tạo nhóm '$g'."
  log_action INFO "Tạo nhóm $g"
}

# ====== XÓA NHÓM ======
delete_group() {
  read -rp "Nhập tên nhóm cần xóa: " g
  if ! group_exists "$g"; then
    notify_error "Không tồn tại nhóm '$g'."
    return
  fi
  groupdel "$g" && notify_success "Đã xóa nhóm '$g'." && log_action INFO "Xóa nhóm $g"
}

# ====== THÊM NGƯỜI DÙNG VÀO NHÓM ======
add_user_to_group() {
  read -rp "Nhập tên người dùng: " u
  read -rp "Nhập tên nhóm: " g

  if ! user_exists "$u"; then notify_error "Không tồn tại người dùng '$u'."; return; fi
  if ! group_exists "$g"; then notify_error "Không tồn tại nhóm '$g'."; return; fi

  usermod -aG "$g" "$u" && notify_success "Đã thêm '$u' vào nhóm '$g'." && \
  log_action INFO "Thêm $u vào nhóm $g"
}

# ====== XÓA NGƯỜI KHỎI NHÓM ======
remove_user_from_group() {
  read -rp "Nhập tên người dùng: " u
  read -rp "Nhập tên nhóm: " g

  if ! user_exists "$u"; then notify_error "Không tồn tại người dùng '$u'."; return; fi
  if ! group_exists "$g"; then notify_error "Không tồn tại nhóm '$g'."; return; fi

  gpasswd -d "$u" "$g" && notify_success "Đã xóa '$u' khỏi nhóm '$g'." && \
  log_action INFO "Xóa $u khỏi nhóm $g"
}

# ====== LIỆT KÊ TẤT CẢ NHÓM ======
list_all_groups() {
  echo "Danh sách nhóm:"
  cut -d: -f1 /etc/group
  log_action INFO "Liệt kê tất cả nhóm"
}
