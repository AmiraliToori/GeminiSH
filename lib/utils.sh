#!/usr/bin/env bash

function error_page {
  local error_text="$1"
  local loading_text="$2"
  clear >&2
  gum style \
    --background "#070708" \
    --border hidden \
    --bold \
    --border-foreground 212 \
    --width 50 \
    --margin "1 20" \
    --padding "1 2" \
    --align center \
    --foreground "#E40406" \
    " $error_text " >&2

  gum spin --spinner="dot" \
    --align="left" \
    --title "$loading_text" \
    -- sleep 3 >&2
  clear >&2
}

function generate_models_list {
  curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GEMINI_API_KEY" |
    jq -r '.models[].name' 2>/dev/null |
    awk -F/ '{print $2}' || printf "API Key not set or Invalid" && exit 1
}

function gradient_text_rgb {
  local text="$1"
  local start_r=$2
  local start_g=$3
  local start_b=$4
  local end_r=$5
  local end_g=$6
  local end_b=$7
  local segments=$((${#text}))
  local i
  local r_increment
  local g_increment
  local b_increment
  local current_r
  local current_g
  local current_b

  r_increment=$(((end_r - start_r) / segments))
  g_increment=$(((end_g - start_g) / segments))
  b_increment=$(((end_b - start_b) / segments))

  current_r=$start_r
  current_g=$start_g
  current_b=$start_b

  for ((i = 0; i < segments; i++)); do
    printf "\e[38;2;${current_r};${current_g};${current_b}m${text:$i:1}"
    current_r=$((current_r + r_increment))
    current_g=$((current_g + g_increment))
    current_b=$((current_b + b_increment))
    # Clamp to the 0-255 range if needed
  done

  printf "\e[0m"
}

function prompt_box {
  clear >&2
  local prompt="$1"
  gum style \
    --align left \
    "$(gum style --foreground 212 --bold --underline "PROMPT:") $prompt" >&2
}
