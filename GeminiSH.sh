#!/usr/bin/env bash

# Load configurations and UI utilities first
source ./configs/gum_vars.sh
source ./lib/ui.sh # ui.sh also sources gradient_color.sh if needed by its functions

#--------Global Configurations-----------#
model="gemini-1.5-flash" # Default model, can be changed by choose_model_menu in ui.sh
prompt="" # Will be set by UI or command-line argument

#--------Function to process prompt and display result-----------#
process_prompt_and_display() {
  if [ -z "$prompt" ]; then
    # This case should ideally be handled before calling this function,
    # e.g., by take_prompt_menu or command-line arg check.
    error_page "Prompt is empty. Cannot proceed." "Error"
    return 1
  fi

  # Display the selected model using the gradient color script
  # Make sure gradient_color.sh is executable and sourced/callable
  # ui.sh might already source it, or we ensure it's available.
  # For direct calls (e.g. command line arg), we might need to call intro elements selectively.
  # ./lib/gradient_color.sh "MODEL: $model" 255 0 0 0 0 255
  # Decided to keep model display within the standard intro or when model is chosen.
  # For direct CLI prompt, the focus is on quick answer.

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

  # Show a spinner while fetching
  local result
  result=$(gum spin --spinner.foreground "$SPINNER_COLOR" --title "Thinking..." -- \
    curl "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$GEMINI_API_KEY" \
      -s \
      -H 'Content-Type: application/json' \
      -X POST \
      -d "$JSON_PAYLOAD" |
    jq -r '.candidates[0].content.parts[0].text'
  )

  if [[ -n "$result" && "$result" != "null" ]]; then
    local today_date="$(date "+%Y-%m-%d")"
    local today_time="$(date "+%H:%M:%S")"
    mkdir -p "./history/$today_date"

    # Display with glow and save to history
    printf "%s\n" "$result" | tee "./history/$today_date/$today_time.md" | glow -

    # Ask to copy to clipboard
    if gum confirm "Copy to clipboard?"; then
      printf "%s" "$result" | gum write # gum write should handle piping to clipboard
      gum style --padding "0 1" --foreground "$SUCCESS_COLOR" "Copied to clipboard!"
    else
      gum style --padding "0 1" --foreground "$INFO_COLOR" "Not copied."
    fi
  else
    # More specific error handling for API issues
    local error_message=$(echo "$result" | jq -r '.error.message' 2>/dev/null)
    if [[ -n "$error_message" && "$error_message" != "null" ]]; then
        error_page "API Error: $error_message" "Error"
    else
        error_page "No response or empty result from API. Check connection or API key." "Error"
    fi
    # Decide if we should re-run or exit. For CLI mode, exit is better.
    # For interactive, ui.sh handles re-prompting or going to menu.
    return 1 # Indicate failure
  fi
}

#--------Script Entry Point-----------#

# 1. Check for GEMINI_API_KEY
if [ -z "$GEMINI_API_KEY" ]; then
  gum style \
    --border double --border-foreground "$ERROR_COLOR" \
    --background "$ERROR_BACKGROUND_COLOR" \
    --align center --width 50 --padding "1 2" \
    "$(gum style --bold --foreground "$ERROR_COLOR" "Error: GEMINI_API_KEY is not set.")" \
    "Please set the GEMINI_API_KEY environment variable." \
    "You can get a key from Google AI Studio."
  exit 1
fi

# 2. Check for command-line argument
if [ -n "$1" ]; then
  prompt="$1"
  # Optionally, display which model is being used if running directly
  gum spin --execute --title "Processing..." -- \
  ./lib/gradient_color.sh "Using Model: $model" 255 0 0 0 0 255

  process_prompt_and_display
else
  # No command-line argument, start interactive UI
  # ui.sh should handle the intro and options menu.
  # The 'Prompt' option in ui.sh will call take_prompt_menu,
  # which should then set the global 'prompt' and call 'process_prompt_and_display'.
  intro # from ui.sh
  options # from ui.sh, which will eventually call process_prompt_and_display
fi
