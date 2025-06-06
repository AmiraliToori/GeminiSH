#!/usr/bin/env bash

#--------Color-Values---------#
BOLD="\x1b[1m"

BLUE="\x1b[34m"
CYAN="\x1b[36m"

RESET="\x1b[0m"

#--------Configurations-----------#
MODEL="gemini-2.0-flash" # Default

#--------Models---------#
list_models() {
  curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GEMINI_API_KEY" |
    jq -r '.models[].name' 2>/dev/null |
    awk -F/ '{print $2}' || printf "API Key not set or Invalid"
  exit 0
}

#--------Main Function---------#
main() {
  printf "\n${BLUE}MODEL: ${CYAN}${BOLD}${MODEL^^}${RESET}\n"
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

  curl "https://generativelanguage.googleapis.com/v1beta/models/"$MODEL":generateContent?key=$GEMINI_API_KEY" \
    -s \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "$JSON_PAYLOAD" |
    jq -r '.candidates[0].content.parts[0].text' | glow -
}

#---------Usage---------#
usage() {
  cat <<-EOF
Usage: ./GeminiSH.sh <prompt> [options]

A simple script to have a conversation with Gemini.

OPTIONS:
  -p, -p <Your prompt>             Set the prompt to send to Gemini.
  -l,                              Print list of models.
  -m, -m <Name of the model>       Set the model among the models available.
EOF
  exit 1
}

#----handling-options-----#
while getopts ":p:m:l" opt; do
  case "$opt" in
  p) prompt="$OPTARG" ;;
  l) list_models ;;
  m) MODEL="$OPTARG" ;;
  \?)
    printf "Invalide option -$OPTARG\n" >&2
    usage
    ;;
  :)
    printf "Option -$OPTARG requires an argument." >&2
    usage
    ;;
  esac
done

main
