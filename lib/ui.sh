#!/usr/bin/env bash

function change_colors_menu() {
  local selected_color=$(gum choose "Default" "Gum")
}

function intro() {
  clear
  gum style \
    --background "#070708" \
    --border hidden \
    --align center \
    --width 50 \
    --margin "1 2" \
    --padding "2 4" \
    $(gum style --bold $(./lib/gradient_color.sh "GeminiSH" 255 0 0 0 0 255)) \
    'Developed by: Amirali Toori' \
    $(gum style --bold $(./lib/gradient_color.sh "GitHub:@AmiraliToori" 0 248 242 65 195 0)) \
    "Current model: $model"
}

function error_spinner() {
  local error_text="$1"
  gum spin --spinner="dot" \
    --title.foreground="#FFFF00" \
    --spinner.foreground="#E7E7E7" \
    --align="left" \
    --title="$1" \
    -- sleep 3
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
    error_spinner "Prompt cannot be empty. Please try again."
    take_prompt_menu
  fi
  prompt_box "$prompt"
}

function choose_model_menu() {
  clear
  model=$(gum choose $(./lib/models_list.sh) 2>/dev/null)
  if [[ -z $model ]]; then
    error_spinner "No model selected. Please try again."
    ./GeminiSH.sh
  else
    clear
    intro
    options
  fi
}

function history_menu() {
  gum pager --show-line-numbers <"$(gum file ./history)"
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
