#!/usr/bin/env bash

#--------Color-Values---------#
BOLD="\x1b[1m"

BLUE="\x1b[34m"
CYAN="\x1b[36m"

RESET="\x1b[0m"

#--------Configurations-----------#
PROMPT="$1"
MODEL="gemini-2.0-flash" # Default

if [ -z "${1// /}" ]; then
  echo "Usage: $0 \"<Your prompt goes here>\""
  exit 1
fi

if [ -n "$2" ] && [[ "${2,,}" =~ "^gemini" ]]; then
  MODEL="$2"
fi

printf "\n${BLUE}MODEL: ${CYAN}${BOLD}${MODEL^^}${RESET}\n"

JSON_PAYLOAD=$(jq -n \
  --arg prompt_var "$PROMPT" \
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

curl "https://generativelanguage.googleapis.com/v1beta/models/"$MODEL":generateContent?key=$GEMINI_API_KEY" \
  -s \
  -H 'Content-Type: application/json' \
  -X POST \
  -d "$JSON_PAYLOAD" |
  jq -r '.candidates[0].content.parts[0].text' | glow -
