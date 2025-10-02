#!/usr/bin/env bash
# Source utils
. "$(dirname "$0")/utils.sh"

create_user() {
  read -rp "Enter username: " username
  if user_exists "$username"; then
    echo "${yellow}User already exists.${reset}"; return
  fi
  useradd -m -s /bin/bash "$username"
  passwd "$username"
  chage -d 0 "$username"
  chage -M 90 "$username"
  echo "${green}User $username created.${reset}"
  log_action INFO "Created user $username"
}

delete_user() {
  read -rp "Enter username to delete: " username
  if ! user_exists "$username"; then
    echo "${yellow}User not found.${reset}"; return
  fi
  if is_user_logged_in "$username"; then
    echo "${red}Warning: user is logged in!${reset}"
  fi
  userdel -r "$username" && log_action INFO "Deleted user $username"
}

change_password() {
  read -rp "Enter username: " username
  if ! user_exists "$username"; then echo "Not found"; return; fi
  passwd "$username"
  log_action INFO "Changed password for $username"
}

show_user_info() {
  read -rp "Enter username: " username
  id "$username"; chage -l "$username"
  log_action INFO "Displayed info for $username"
}

list_all_users() {
  cut -d: -f1 /etc/passwd
  log_action INFO "Listed all users"
}

who_is_logged_in() { who; log_action INFO "Checked who"; }
last_logins_for_user() { read -rp "User: " u; last "$u" | head; }

