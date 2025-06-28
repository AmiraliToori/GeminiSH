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
  gum style \
    --background "$BACKGROUND_COLOR" \
    --foreground "$FOREGROUND_COLOR" --border-foreground "$SECONDARY_COLOR" --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'GeminiSH' 'Developed by: Amirali Toori' 'GitHub:@AmirAliToori'
}

function prompt_box() {
  local prompt="$1"
  gum style \
    --background "$BACKGROUND_COLOR" \
    --foreground "$FOREGROUND_COLOR" --border-foreground "$SECONDARY_COLOR" --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    "$prompt"
}

function options() {
  local option=$(gum choose "Prompt" "Choose a model" "Exit")

  case "$option" in
  "Prompt")
    prompt=$(gum write --placeholder "Your Prompt")
    if [[ -z "${prompt// /}" ]]; then
      gum style --foreground "$ERROR_COLOR" "Prompt cannot be empty. Please try again."
      options
    fi
    prompt_box "$prompt"
    ;;
  "Choose a model")
    model=$(gum choose $(./lib/models_list.sh))
    if [[ -z $model ]]; then
      gum style --foreground "$ERROR_COLOR" "No model selected. Please try again."
      options
    else
      gum style --foreground "$PRIMARY_COLOR" "You selected: $model"
      options
    fi
    ;;
  "Exit")
    exit 0
    ;;
  esac
}

intro
options
