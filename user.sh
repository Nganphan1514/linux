#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

# ====== TẠO NGƯỜI DÙNG ======
create_user() {
  read -rp "Nhập tên người dùng mới: " username
  if user_exists "$username"; then
    notify_warn "Người dùng '$username' đã tồn tại."
    return
  fi

  useradd -m -s /bin/bash "$username"
  passwd "$username"
  chage -d 0 "$username"
  chage -M 90 "$username"

  notify_success "Đã tạo người dùng '$username' (buộc đổi mật khẩu lần đầu, hết hạn sau 90 ngày)."
  log_action INFO "Tạo người dùng $username"
}

# ====== XÓA NGƯỜI DÙNG ======
delete_user() {
  read -rp "Nhập tên người dùng cần xóa: " username
  if ! user_exists "$username"; then
    notify_warn "Không tìm thấy người dùng '$username'."
    return
  fi

  if is_user_logged_in "$username"; then
    notify_warn "Người dùng '$username' hiện đang đăng nhập!"
  fi

  userdel -r "$username" && notify_success "Đã xóa người dùng '$username'." && \
  log_action INFO "Xóa người dùng $username"
}

# ====== ĐỔI MẬT KHẨU ======
change_password() {
  read -rp "Nhập tên người dùng: " username
  if ! user_exists "$username"; then
    notify_error "Không tồn tại người dùng '$username'."
    return
  fi

  passwd "$username"
  notify_success "Đã đổi mật khẩu cho '$username'."
  log_action INFO "Đổi mật khẩu cho $username"
}

# ====== HIỂN THỊ THÔNG TIN ======
show_user_info() {
  read -rp "Nhập tên người dùng: " username
  if ! user_exists "$username"; then
    notify_error "Không tồn tại người dùng '$username'."
    return
  fi

  echo "Thông tin người dùng:"
  id "$username"
  chage -l "$username"
  log_action INFO "Xem thông tin người dùng $username"
}

# ====== LIỆT KÊ NGƯỜI DÙNG ======
list_all_users() {
  echo "Danh sách người dùng hệ thống:"
  cut -d: -f1 /etc/passwd
  log_action INFO "Liệt kê tất cả người dùng"
}

# ====== AI ĐANG ĐĂNG NHẬP ======
who_is_logged_in() {
  echo "Người dùng đang đăng nhập:"
  who
  log_action INFO "Kiểm tra người dùng đang đăng nhập"
}

# ====== LỊCH SỬ ĐĂNG NHẬP ======
last_logins_for_user() {
  read -rp "Nhập tên người dùng: " username
  if ! user_exists "$username"; then
    notify_error "Không tồn tại người dùng '$username'."
    return
  fi

  echo "Lịch sử đăng nhập gần đây của '$username':"
  last "$username" | head
  log_action INFO "Xem lịch sử đăng nhập $username"
}
