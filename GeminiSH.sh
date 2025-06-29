#!/usr/bin/env bash

#--------Configurations-----------#
model="gemini-2.5-flash" # Default

#--------Main Function---------#
main() {
  if [ -z "$prompt" ]; then
    exit 0
  fi

  ./lib/gradient_color.sh "MODEL: $model" 255 0 0 0 0 255
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

  local result=$(curl "https://generativelanguage.googleapis.com/v1beta/models/"$model":generateContent?key=$GEMINI_API_KEY" \
    -s \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "$JSON_PAYLOAD" |
    jq -r '.candidates[0].content.parts[0].text')

  if [[ -n "$result" ]]; then
    local today_date="$(date "+%Y-%m-%d")"
    local today_time="$(date "+%H:%M:%S")"
    mkdir -p "./history/$today_date"

    printf "$result" | tee "./history/$today_date/$today_time.md" | glow -
  fi
}

source ./lib/ui.sh
main
