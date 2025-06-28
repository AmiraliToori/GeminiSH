#!/usr/bin/env bash

#--------Colors-----------#
PRIMARY_COLOR="#5B9CFF" #Gemini Blue

#--------Configurations-----------#
model="gemini-2.5-flash" # Default

#--------Main Function---------#
main() {
  gum style --foreground "$PRIMARY_COLOR" --bold "MODEL: $model"
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
