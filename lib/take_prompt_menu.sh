#!/usr/bin/env bash

source ./lib/utils.sh

model="$1"

function main {
  local JSON_PAYLOAD=$(jq -n \
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

  printf "$result"
}

prompt=$(gum write --height 15 --show-line-numbers --placeholder="Write your prompt")
if [[ -z "${prompt// /}" ]]; then
  error_page "Prompt cannot be empty. Please try again." "Loading"
  printf "0"
else

  export -f main
  export prompt
  export model
  export GEMINI_API_KEY

  result=$(gum spin --spinner="dot" --title="Thinking..." -- bash -c 'main')
  clear >&2
  if [[ -n "$result" ]]; then
    today_date="$(date "+%Y-%m-%d")"
    today_time="$(date "+%H:%M:%S")"
    mkdir -p "./history/$today_date"

    prompt_box "$prompt"
    printf "$result" | tee "./history/$today_date/$today_time.md" | glow - >&2
  else
    error_page " There is something wrong, Please check the connection." "Loading"
  fi
fi
