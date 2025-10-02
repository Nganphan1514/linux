#!/usr/bin/env bash
. "$(dirname "$0")/utils.sh"

create_group() {
  read -rp "Enter group: " g
  if group_exists "$g"; then echo "Exists"; return; fi
  groupadd "$g"
  echo "Group $g created"; log_action INFO "Created group $g"
}

delete_group() {
  read -rp "Enter group: " g
  groupdel "$g" && log_action INFO "Deleted group $g"
}

add_user_to_group() {
  read -rp "User: " u; read -rp "Group: " g
  usermod -aG "$g" "$u" && log_action INFO "Added $u to $g"
}

remove_user_from_group() {
  read -rp "User: " u; read -rp "Group: " g
  gpasswd -d "$u" "$g" && log_action INFO "Removed $u from $g"
}

list_all_groups() { cut -d: -f1 /etc/group; }

