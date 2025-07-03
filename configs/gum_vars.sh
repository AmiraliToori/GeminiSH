#!/usr/bin/env bash

# This file is now primarily responsible for loading the selected theme
# and applying its colors to the GUM environment variables.

# Source the theme definitions and the apply_theme function
# The THEME_CONFIG_DIR should be the directory where this script itself is located.
THEME_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${THEME_CONFIG_DIR}/themes.sh"

# The GEMINI_SH_CURRENT_THEME variable is expected to be set by themes.sh
# (either from environment or a default).
# The apply_theme function in themes.sh will then set all necessary
# GUM_..._FOREGROUND/BACKGROUND variables as well as general color vars
# like BACKGROUND_COLOR, FOREGROUND_COLOR, ERROR_COLOR etc.

# Example: if GEMINI_SH_CURRENT_THEME is "Dracula", apply_theme "Dracula"
# will set GUM_CHOOSE_CURSOR_FOREGROUND to THEME_DRACULA_PRIMARY, etc.

# Most of the original hardcoded GUM_EXPORT variables are now dynamically set
# within the apply_theme function in themes.sh.

# You can add any non-color related GUM settings here if needed.
# For example:
# export GUM_CHOOSE_HEIGHT=10
# export GUM_INPUT_WIDTH=80

# Ensure this script can be sourced without error
true
