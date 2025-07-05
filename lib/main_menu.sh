#!/usr/bin/env bash
model="$1"

source ./lib/utils.sh

clear >&2
gum style \
  --background "#070708" \
  --border hidden \
  --align center \
  --width 50 \
  --margin "1 2" \
  --padding "2 4" \
  $(gum style --bold $(gradient_text_rgb "GeminiSH" 255 0 0 0 0 255)) \
  'Developed by: Amirali Toori' \
  $(gum style --bold $(gradient_text_rgb "GitHub:@AmiraliToori" 0 248 242 65 195 0)) \
  "Current model: $model" >&2

gum choose --header "The Menu:" "Prompt" "Choose a model" "History" "Exit"
