#!/usr/bin/env bash

model="gemini-2.5-flash" # Default
program_run=1

source ./configs/gum_vars.sh
while ((program_run == 1)); do
  main_menu_option=$(./lib/main_menu.sh "$model")

  case "$main_menu_option" in
  "Prompt") program_run=$(./lib/take_prompt_menu.sh "$model") ;;
  "Choose a model") model=$(./lib/choose_model_menu.sh "$model") ;;
  "History") ./lib/history_menu.sh ;;
  "Exit") program_run=$(./lib/exit_menu.sh) ;;
  *)
    clear
    program_run=0
    ;;
  esac
done
