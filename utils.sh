#!/usr/bin/env bash

LOGFILE="/var/log/user_group_manager.log"
touch "$LOGFILE"; chmod 600 "$LOGFILE"

bold="$(tput bold 2>/dev/null || echo "")"
reset="$(tput sgr0 2>/dev/null || echo "")"
red="$(tput setaf 1 2>/dev/null || echo "")"
green="$(tput setaf 2 2>/dev/null || echo "")"
yellow="$(tput setaf 3 2>/dev/null || echo "")"
blue="$(tput setaf 4 2>/dev/null || echo "")"

log_action() {
  local level="$1"; shift
  local message="$*"
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOGFILE"
}

user_exists() { id "$1" &>/dev/null; }
group_exists() { getent group "$1" &>/dev/null; }
is_user_logged_in() { who | awk '{print $1}' | grep -xq "$1"; }

