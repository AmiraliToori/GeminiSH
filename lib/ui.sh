#!/usr/bin/env bash

function change_colors_menu() {
  local selected_color=$(gum choose "Default" "Gum")
  ./lib/colors.sh "$selected_color"
  source ./lib/colors.sh
  #./GeminiSH.sh
}

function intro() {
  clear
  gum style \
    --background "$BACKGROUND_COLOR" \
    --foreground "$FOREGROUND_COLOR" \
    --border-foreground "$SECONDARY_COLOR" \
    --border double \
    --align center \
    --width 50 \
    --margin "1 2" \
    --padding "2 4" \
    $(gum style --bold $(./lib/gradient_color.sh "GeminiSH" 255 0 0 0 0 255)) \
    'Developed by: Amirali Toori' \
    $(gum style --bold $(./lib/gradient_color.sh "GitHub:@AmiraliToori" 0 248 242 65 195 0)) \
    "Current model: $model"
}

function error_page() {
  local error_text="$1"
  local loading_text="$2"
  clear
  gum style \
    --border rounded \
    --border-foreground 212 \
    --width 50 \
    --margin "1 20" \
    --align center \
    --foreground "$ERROR_COLOR" \
    " $1 "
  gum spin -s dot --title "$2" -- sleep 1
  clear
}

function prompt_box() {
  clear
  local prompt="$1"
  gum style \
    --foreground "$FOREGROUND_COLOR" \
    --align left \
    "$(gum style --foreground 212 --bold --underline "PROMPT:") $prompt"
}

function take_prompt_menu() {
  prompt=$(gum write --height 15 --placeholder="Write your prompt")
  if [[ -z "${prompt// /}" ]]; then
    error_page "Prompt cannot be empty. Please try again." "Loading"
    take_prompt_menu
  fi
  prompt_box "$prompt"
}

function choose_model_menu() {
  clear
  model=$(gum choose $(./lib/models_list.sh))
  if [[ -z $model ]]; then
    error_page "No model selected. Please try again." "Loading"
    ./GeminiSH.sh
  else
    clear
    intro
    options
  fi
}

function history_menu() {
  gum pager <"$(gum file ./history)"
  ./GeminiSH.sh
}

function exit_menu() {
  clear
  gum confirm && exit 0 || ./GeminiSH.sh
}

function options() {
  local option=$(gum choose --header "The Menu:" "Prompt" "Choose a model" "History" "Change Colors" "Exit")

  case "$option" in
  "Prompt") take_prompt_menu ;;
  "Choose a model") choose_model_menu ;;
  "History") history_menu ;;
  "Change Colors") change_colors_menu ;;
  "Exit") exit_menu ;;
  *)
    clear
    exit 0
    ;;
  esac
}

intro
options
