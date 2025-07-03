#!/usr/bin/env bash

# This script is intended to be sourced by GeminiSH.sh
# It expects variables like $model, $FOREGROUND_COLOR, $ERROR_COLOR etc. to be set (e.g., from configs/gum_vars.sh)
# It also expects functions like process_prompt_and_display to be available from GeminiSH.sh

# Ensure gradient_color.sh is found relative to the main script's directory structure
# When this script (lib/ui.sh) is sourced by GeminiSH.sh (in root),
# paths should be relative to the root, so ./lib/gradient_color.sh is correct.
GRADIENT_SCRIPT="./lib/gradient_color.sh"

function intro() {
  clear
  # Check if gum_vars.sh was sourced by the main script, providing $MAIN_COLOR, etc.
  # These are now defined in configs/gum_vars.sh and sourced by GeminiSH.sh
  gum style \
    --background "$BACKGROUND_COLOR" \
    --border hidden \
    --align center \
    --width 50 \
    --margin "1 2" \
    --padding "2 4" \
    "$(gum style --bold $($GRADIENT_SCRIPT "GeminiSH" 255 0 0 0 0 255))" \
    "Developed by: Amirali Toori" \
    "$(gum style --bold $($GRADIENT_SCRIPT "GitHub:@AmiraliToori" 0 248 242 65 195 0))" \
    "$(gum style --italic --foreground "$INFO_COLOR" "Current model: $model")"
}

function error_page() {
  local error_message="$1"
  # local loading_text="$2" # Original second arg, now using a fixed title for spin
  clear
  gum style \
    --background "$ERROR_BACKGROUND_COLOR" \
    --border double --border-foreground "$ERROR_COLOR" \
    --bold \
    --width 50 \
    --margin "1 20" \
    --padding "1 2" \
    --align center \
    --foreground "$ERROR_COLOR" \
    "ERROR: $error_message"
  gum spin --spinner.foreground "$SPINNER_COLOR" \
    --align="center" \
    --title "Acknowledging error..." -- sleep 2 # Increased sleep for visibility
  clear
}

function take_prompt_menu() {
  clear
  gum style --padding "1 2" --bold --underline --foreground "$FOREGROUND_COLOR" --background "$BACKGROUND_COLOR" "Enter your prompt below (Ctrl+D when done):"
  # The global 'prompt' variable (from GeminiSH.sh) will be set here
  # Removed problematic flags: --text.foreground, --base.background, --cursor.foreground, --placeholder.foreground
  # Theming will rely on GUM_WRITE_* environment variables set in themes.sh
  prompt=$(gum write --char-limit 0 --placeholder "Type your prompt here..." --height 15 --show-line-numbers)

  if [[ -z "${prompt// /}" ]]; then # Check if prompt is empty or only whitespace
    error_page "Prompt cannot be empty. Please try again."
    options # Return to main menu
  else
    # Call the main processing function from GeminiSH.sh
    process_prompt_and_display
    # After processing, decide what to do. Typically, return to menu or offer to continue.
    # For now, let's go back to the main menu.
    gum style --padding "0 1" --foreground "$INFO_COLOR" "Press any key to return to the menu..."
    read -n 1 -s # Wait for a key press
    options
  fi
}

function choose_model_menu() {
  clear
  gum style --padding "1 2" --bold --underline --foreground "$FOREGROUND_COLOR" --background "$BACKGROUND_COLOR" "Select a Gemini Model:"
  local selected_model
  # Use a subshell for models_list.sh to avoid it exiting the main script on error
  local models_output
  models_output=$(./lib/models_list.sh)

  if [[ "$models_output" == "API Key not set or Invalid" || -z "$models_output" ]]; then
    error_page "Could not fetch models. API Key might be invalid or missing."
    options
    return
  fi

  selected_model=$(echo "$models_output" | gum choose)

  if [[ -z "$selected_model" ]]; then
    gum style --padding "0 1" --foreground "$WARNING_COLOR" "No model selected. Returning to menu."
    sleep 1
  else
    model="$selected_model" # Update the global model variable
    gum style --padding "0 1" --foreground "$SUCCESS_COLOR" "Model set to: $model"
    sleep 1
  fi
  # Refresh intro to show new model and then show options
  intro
  options
}

function history_menu() {
  clear
  if [ -d "./history" ] && [ "$(ls -A ./history)" ]; then
    gum style --padding "1 2" --bold --underline --foreground "$FOREGROUND_COLOR" --background "$BACKGROUND_COLOR" "Select a history file to view:"
    # Allow choosing a file, then display with gum pager
    local selected_file
    selected_file=$(gum file ./history)
    if [ -n "$selected_file" ]; then
        gum pager --show-line-numbers < "$selected_file"
    else
        gum style --padding "0 1" --foreground "$INFO_COLOR" "No file selected or history is empty."
        sleep 1
    fi
  else
    gum style --padding "1 2" --foreground "$INFO_COLOR" "History directory is empty or does not exist."
    sleep 2
  fi
  options # Return to main menu
}

function exit_menu() {
  clear
  if gum confirm "Are you sure you want to exit GeminiSH?"; then
    gum style --padding "1 2" --bold --foreground "$INFO_COLOR" "Exiting GeminiSH. Goodbye!"
    sleep 1
    clear
    exit 0
  else
    options # Return to main menu
  fi
}

# File to store the current theme choice
THEME_STORAGE_FILE="$HOME/.config/geminish/theme"

function load_theme_preference() {
    if [ -f "$THEME_STORAGE_FILE" ]; then
        export GEMINI_SH_CURRENT_THEME=$(cat "$THEME_STORAGE_FILE")
    else
        # Default theme if file doesn't exist - this should align with themes.sh default
        export GEMINI_SH_CURRENT_THEME="Catppuccin-Mocha"
    fi
    # Ensure the theme is applied by sourcing gum_vars.sh which sources themes.sh
    # This needs to be done carefully to avoid circular dependencies or multiple sourcing issues.
    # It's better if GeminiSH.sh sources gum_vars.sh once after this is set.
}

function save_theme_preference() {
    local theme_name="$1"
    mkdir -p "$(dirname "$THEME_STORAGE_FILE")"
    echo "$theme_name" > "$THEME_STORAGE_FILE"
    export GEMINI_SH_CURRENT_THEME="$theme_name"
}

function choose_theme_menu() {
  clear
  gum style --padding "1 2" --bold --underline --foreground "$FOREGROUND_COLOR" --background "$BACKGROUND_COLOR" "Select a Theme:"

  # List of available themes (ensure these match the prefixes in themes.sh)
  local themes=("Light" "Dark" "Dracula" "Catppuccin-Latte" "Catppuccin-Frappe" "Catppuccin-Macchiato" "Catppuccin-Mocha")
  local selected_theme

  selected_theme=$(printf "%s\n" "${themes[@]}" | gum choose --header "Available Themes")

  if [[ -n "$selected_theme" ]]; then
    save_theme_preference "$selected_theme"

    # Re-apply the theme. This requires sourcing the theme application logic.
    # This assumes THEME_CONFIG_DIR is available or correctly determined.
    # configs/gum_vars.sh sources themes.sh which contains apply_theme
    # Sourcing gum_vars.sh should re-apply everything.
    # Need to be careful with pathing if this function is called from various places.
    # Assuming this script (ui.sh) is in lib/ and gum_vars.sh is in configs/
    # The main script GeminiSH.sh sources configs/gum_vars.sh at the start.
    # We need to re-source it here to apply changes immediately.
    # Assuming this script (ui.sh) is sourced by GeminiSH.sh in the repo root,
    # the path to configs/gum_vars.sh is relative to the repo root.
    if [ -f "./configs/gum_vars.sh" ]; then
        source "./configs/gum_vars.sh"
    else
        # This case should ideally not be reached if the script structure is maintained.
        error_page "Critical: Theme config 'gum_vars.sh' not found. Cannot apply theme."
        # Minimal recovery: proceed without re-applying, theme changes might not be visible until restart.
    fi

    gum style --padding "0 1" --foreground "$SUCCESS_COLOR" --background "$BACKGROUND_COLOR" "Theme set to: $selected_theme"
    sleep 1
  else
    gum style --padding "0 1" --foreground "$WARNING_COLOR" --background "$BACKGROUND_COLOR" "No theme selected. No changes made."
    sleep 1
  fi
  # Refresh intro and return to options menu to show the new theme
  intro
  options
}

function options() {
  clear
  # load_theme_preference # Load theme before showing menu - This should be done in GeminiSH.sh startup
  intro # Show intro screen before options every time for context
  local option
  option=$(gum choose \
    --header.foreground "$HEADER_COLOR" --header "GeminiSH Main Menu - Model: $model" \
    --item.foreground "$ITEM_COLOR" \
    --selected.foreground "$SELECTED_ITEM_COLOR" \
    "New Prompt" "Choose Model" "View History" "Choose Theme" "Exit")

  case "$option" in
  "New Prompt") take_prompt_menu ;;
  "Choose Model") choose_model_menu ;;
  "View History") history_menu ;;
  "Choose Theme") choose_theme_menu ;;
  "Exit") exit_menu ;;
  *)
    # This case should not be reached if gum choose is used correctly
    # but as a fallback, exit.
    gum style --padding "1 2" --foreground "$ERROR_COLOR" "Invalid option. Exiting."
    sleep 1
    clear
    exit 1
    ;;
  esac
}

# Remove the direct calls to intro and options from here.
# GeminiSH.sh will call them when it's in interactive mode.
