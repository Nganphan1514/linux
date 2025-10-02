#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

lock_user() {
  read -rp "User to lock: " u
  usermod -L "$u" && echo "Locked $u" && log_action INFO "Locked $u"
}

unlock_user() {
  read -rp "User to unlock: " u
  usermod -U "$u" && echo "Unlocked $u" && log_action INFO "Unlocked $u"
}

apply_password_policy() {
  read -rp "User: " u
  chage -d 0 "$u"
  chage -M 90 "$u"
  echo "Applied password policy"
}

