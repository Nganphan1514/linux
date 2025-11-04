#!/usr/bin/env bash

# ====== CẤU HÌNH LOG & MÀU ======
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/actions.log"
touch "$LOG_FILE"; chmod 600 "$LOG_FILE"

bold="$(tput bold 2>/dev/null || echo "")"
reset="$(tput sgr0 2>/dev/null || echo "")"
red="$(tput setaf 1 2>/dev/null || echo "")"
green="$(tput setaf 2 2>/dev/null || echo "")"
yellow="$(tput setaf 3 2>/dev/null || echo "")"
blue="$(tput setaf 4 2>/dev/null || echo "")"

# ====== GHI LOG ======
log_action() {
  local level="$1"; shift
  local message="$*"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

# ====== HÀM KIỂM TRA ======
user_exists() { id "$1" &>/dev/null; }
group_exists() { getent group "$1" &>/dev/null; }
is_user_logged_in() { who | awk '{print $1}' | grep -xq "$1"; }
