#!/usr/bin/env bash

# ====== CẤU HÌNH LOG & MÀU ======
LOGFILE="/var/log/user_group_manager.log"
touch "$LOGFILE" 2>/dev/null
chmod 600 "$LOGFILE" 2>/dev/null

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
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOGFILE"
}

# ====== HÀM HỖ TRỢ ======
user_exists() { id "$1" &>/dev/null; }
group_exists() { getent group "$1" &>/dev/null; }
is_user_logged_in() { who | awk '{print $1}' | grep -xq "$1"; }

# ====== THÔNG BÁO CHUNG ======
notify_info()   { echo "${blue}${bold}ℹ️  $1${reset}"; }
notify_success(){ echo "${green}${bold}✅ $1${reset}"; }
notify_warn()   { echo "${yellow}${bold}⚠️  $1${reset}"; }
notify_error()  { echo "${red}${bold}❌ $1${reset}"; }
