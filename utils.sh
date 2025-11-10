#!/usr/bin/env bash
# utils.sh - helper chung cho toàn bộ project

# ====== CẤU HÌNH THƯ MỤC ======
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$BASE_DIR/logs"
EXPORT_DIR="$BASE_DIR/exports"
TMP_DIR="$BASE_DIR/tmp"

mkdir -p "$LOG_DIR" "$EXPORT_DIR" "$TMP_DIR"
LOG_FILE="$LOG_DIR/actions.log"
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

# ====== MÀU VÀ ĐỊNH DẠNG ======
bold="$(tput bold 2>/dev/null || echo "")"
reset="$(tput sgr0 2>/dev/null || echo "")"
red="$(tput setaf 1 2>/dev/null || echo "")"
green="$(tput setaf 2 2>/dev/null || echo "")"
yellow="$(tput setaf 3 2>/dev/null || echo "")"
blue="$(tput setaf 4 2>/dev/null || echo "")"

# ====== LOG HÀNH ĐỘNG ======
log_action() {
  local level="$1"; shift
  local message="$*"
  # an toàn: escape newlines
  local time_stamp
  time_stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '%s [%s] %s\n' "$time_stamp" "$level" "$message" >> "$LOG_FILE"
}

# ====== KIỂM TRA QUYỀN ======
require_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "${red}Vui lòng chạy script với quyền root (sudo).${reset}" >&2
    log_action ERROR "Script yêu cầu root - thoát."
    exit 1
  fi
}

# ====== HÀM KIỂM TRA ======
user_exists() { id "$1" &>/dev/null; }
group_exists() { getent group "$1" &>/dev/null; }

# Validate username: bắt đầu bằng chữ thường/underscore, chỉ chứa a-z0-9_- ; length 1-32
valid_username() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

# Validate group name: tương tự username
valid_groupname() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

# Safe run: chạy lệnh, log lỗi khi thất bại
safe_run() {
  "$@"
  local rc=$?
  if [ $rc -ne 0 ]; then
    log_action ERROR "Lệnh thất bại (rc=$rc): $*"
  fi
  return $rc
}
