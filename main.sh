#!/usr/bin/env bash
. "$(dirname "$0")/user.sh"
. "$(dirname "$0")/group.sh"
. "$(dirname "$0")/security.sh"

main_menu() {
  while true; do
    echo "=== MAIN MENU ==="
    echo "1) User menu"
    echo "2) Group menu"
    echo "3) Security menu"
    echo "4) Exit"
    read -rp "Choose: " c
    case $c in
      1) user_menu ;;
      2) group_menu ;;
      3) security_menu ;;
      4) exit 0 ;;
    esac
  done
}

user_menu() {
  while true; do
    echo "--- USER MENU ---"
    echo "1) Create user"
    echo "2) Delete user"
    echo "3) Change password"
    echo "4) Show info"
    echo "5) List users"
    echo "6) Who is logged in"
    echo "7) Last logins"
    echo "8) Back"
    read -rp "Choose: " c
    case $c in
      1) create_user ;;
      2) delete_user ;;
      3) change_password ;;
      4) show_user_info ;;
      5) list_all_users ;;
      6) who_is_logged_in ;;
      7) last_logins_for_user ;;
      8) return ;;
    esac
  done
}

group_menu() {
  while true; do
    echo "--- GROUP MENU ---"
    echo "1) Create group"
    echo "2) Delete group"
    echo "3) Add user to group"
    echo "4) Remove user from group"
    echo "5) List groups"
    echo "6) Back"
    read -rp "Choose: " c
    case $c in
      1) create_group ;;
      2) delete_group ;;
      3) add_user_to_group ;;
      4) remove_user_from_group ;;
      5) list_all_groups ;;
      6) return ;;
    esac
  done
}

security_menu() {
  while true; do
    echo "--- SECURITY MENU ---"
    echo "1) Lock user"
    echo "2) Unlock user"
    echo "3) Apply password policy"
    echo "4) Back"
    read -rp "Choose: " c
    case $c in
      1) lock_user ;;
      2) unlock_user ;;
      3) apply_password_policy ;;
      4) return ;;
    esac
  done
}

main_menu

