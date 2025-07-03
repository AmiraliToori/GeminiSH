#!/usr/bin/env bash

# Initial source of ui.sh to make load_theme_preference available
source ./lib/ui.sh

# Load theme preference. This will set GEMINI_SH_CURRENT_THEME.
load_theme_preference

# Load configurations (gum_vars.sh which sources themes.sh and applies the theme)
# This must happen *after* load_theme_preference has set GEMINI_SH_CURRENT_THEME
source ./configs/gum_vars.sh
# Re-source ui.sh to ensure it picks up the themed variables correctly for its functions
source ./lib/ui.sh

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
  local curl_output
  local curl_exit_code
  local result

  # Capture curl output and exit code separately
  # Use a temporary file for curl output to handle potential jq errors later
  temp_curl_output=$(mktemp)

  gum spin --spinner.foreground "$SPINNER_COLOR" --title "Thinking..." -- \
    curl "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$GEMINI_API_KEY" \
      -s \
      -w "%{http_code}" \
      -H 'Content-Type: application/json' \
      -X POST \
      -d "$JSON_PAYLOAD" \
      -o "$temp_curl_output"
  curl_exit_code=$?

  http_code=$(tail -n1 "$temp_curl_output")
  # Remove http_code from the end of the file
  # Check if file has more than one line before truncating
  if [[ $(wc -l < "$temp_curl_output") -gt 1 ]]; then
    truncate -s -$(echo -n "$http_code" | wc -c) "$temp_curl_output"
  else
    # if only http_code is there, means body was empty
    echo "" > "$temp_curl_output"
  fi

  curl_output=$(cat "$temp_curl_output")
  rm "$temp_curl_output"

  if [ $curl_exit_code -ne 0 ]; then
    # cURL specific errors
    case $curl_exit_code in
      6) error_page "Could not resolve host. Check your internet connection and DNS." "Network Error"; return 1 ;;
      7) error_page "Failed to connect to host. Check your internet connection." "Network Error"; return 1 ;;
      28) error_page "Operation timed out. Check your internet connection." "Network Error"; return 1 ;;
      *) error_page "curl Error: Exit Code $curl_exit_code. Check connection or API endpoint." "Network Error"; return 1 ;;
    esac
  fi

  # Try to parse the result if curl was successful
  result=$(echo "$curl_output" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)

  # Check if jq parsing was successful and result is non-empty and not "null"
  if [[ -n "$result" && "$result" != "null" ]]; then
    local today_date="$(date "+%Y-%m-%d")"
    local today_time="$(date "+%H:%M:%S")"
    mkdir -p "./history/$today_date"

    # Display with glow and save to history
    printf "%s\n" "$result" | tee "./history/$today_date/$today_time.md" | glow -

    # Ask to copy to clipboard using Nerd Font icon
    if gum confirm --prompt.foreground "$FOREGROUND_COLOR" --selected.background "$PRIMARY_COLOR" --unselected.background "$SECONDARY_COLOR" " Copy to clipboard?"; then
      printf "%s" "$result" | gum write # gum write should handle piping to clipboard
      gum style --padding "0 1" --foreground "$SUCCESS_COLOR" --background "$BACKGROUND_COLOR" "Copied to clipboard!"
    else
      gum style --padding "0 1" --foreground "$INFO_COLOR" --background "$BACKGROUND_COLOR" "Not copied."
    fi
  else
    # Handle cases where jq parsing failed or the result is "null" or empty
    # Also, try to get a more specific error message from the API response
    local api_error_message=$(echo "$curl_output" | jq -r '.error.message' 2>/dev/null)

    if [[ -n "$api_error_message" && "$api_error_message" != "null" ]]; then
      error_page "API Error: $api_error_message" "API Error"
    elif [[ "$http_code" != "200" ]]; then
      error_page "API Request Failed. HTTP Status: $http_code. Response: $curl_output" "API Error"
    else
      # This case means curl succeeded (exit code 0, http 200), but jq parsing failed to find the text
      # or the text was genuinely "null" or empty.
      error_page "No valid response or empty result from API. Check API key or model name. Response: $curl_output" "API Error"
    fi
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
