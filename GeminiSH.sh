#!/usr/bin/env bash

#--------Configurations-----------#
model="gemini-2.5-flash" # Default

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

#--------Main Function---------#
main() {
  gradient_text_rgb "MODEL: $model" 255 0 0 0 0 255
  JSON_PAYLOAD=$(jq -n \
    --arg prompt_var "$prompt" \
    '{
      "contents": [
        {
          "parts": [
            {
              "text": $prompt_var
            }
          ]
        }
      ]
    }')

  curl "https://generativelanguage.googleapis.com/v1beta/models/"$model":generateContent?key=$GEMINI_API_KEY" \
    -s \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "$JSON_PAYLOAD" |
    jq -r '.candidates[0].content.parts[0].text' | glow -
}

source ./lib/ui.sh
main
