#!/usr/bin/env bash

BACKGROUND_COLOR="#1E1F29"   #Deep Inn black
FOREGROUND_COLOR="#E0E7EB"   #Light Gray
PRIMARY_COLOR="#5B9CFF"      #Gemini Blue
SECONDARY_COLOR="#A084E8"    #Celestial Violet
TERTIARY_COLOR="#2DD4BF"     #Tech Teal
WARNING_DATA_COLOR="#FBC02D" #Data Gold
ERROR_COLOR="#EF6B6B"        #Error Red
COMMENT_COLOR="#8E95A2"      #Muted Gray

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
    'GitHub:@AmiraliToori' \
    "Default model: $model"
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
  prompt=$(gum write --height 15 --placeholder "Your Prompt")
  if [[ -z "${prompt// /}" ]]; then
    error_page "Prompt cannot be empty. Please try again." "Loading"
    take_prompt_menu
  fi
  prompt_box "$prompt"
}

function choose_model_menu() {
  model=$(gum choose $(./lib/models_list.sh) 2>/dev/null)
  if [[ -z $model ]]; then
    error_page "No model selected. Please try again." "Loading"
    ./GeminiSH.sh
  else
    gum style --foreground "$PRIMARY_COLOR" "You selected: $model"
    options
  fi
}

function history_menu() {
  local file=$(gum file ./history)
  gum pager file
  ./GeminiSH.sh
}

function exit_menu() {
  clear
  gum confirm && exit 0 || ./GeminiSH.sh
}

function options() {
  local option=$(gum choose --header "The Menu:" "Prompt" "Choose a model" "History" "Exit")

  case "$option" in
  "Prompt") take_prompt_menu ;;
  "Choose a model") choose_model_menu ;;
  "History") history_menu ;;
  "Exit") exit_menu ;;
  esac
}

intro
options
