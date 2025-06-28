#!/usr/bin/env bash

#--------Color-Values---------#
BOLD="\x1b[1m"

BLUE="\x1b[34m"
CYAN="\x1b[36m"

RESET="\x1b[0m"

#--------Configurations-----------#
model="gemini-2.5-flash" # Default

#--------Main Function---------#
main() {
  printf "\n${BLUE}MODEL: ${CYAN}${BOLD}${model^^}${RESET}\n"
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
