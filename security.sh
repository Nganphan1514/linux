#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

# ====== KHÓA NGƯỜI DÙNG ======
lock_user() {
  read -rp "Nhập tên người dùng cần khóa: " u
  if ! user_exists "$u"; then notify_error "Không tồn tại người dùng '$u'."; return; fi

  usermod -L "$u" && notify_success "Đã khóa tài khoản '$u'." && \
  log_action INFO "Khóa tài khoản $u"
}

# ====== MỞ KHÓA NGƯỜI DÙNG ======
unlock_user() {
  read -rp "Nhập tên người dùng cần mở khóa: " u
  if ! user_exists "$u"; then notify_error "Không tồn tại người dùng '$u'."; return; fi

  usermod -U "$u" && notify_success "Đã mở khóa tài khoản '$u'." && \
  log_action INFO "Mở khóa tài khoản $u"
}

# ====== CHÍNH SÁCH MẬT KHẨU ======
apply_password_policy() {
  read -rp "Nhập tên người dùng: " u
  if ! user_exists "$u"; then notify_error "Không tồn tại người dùng '$u'."; return; fi

  chage -d 0 "$u"
  chage -M 90 "$u"
  notify_success "Đã áp dụng chính sách mật khẩu cho '$u' (buộc đổi khi đăng nhập, hết hạn sau 90 ngày)."
  log_action INFO "Áp dụng chính sách mật khẩu cho $u"
}
