#!/usr/bin/env bash
model="$1"

clear >&2
gum style \
  --background "#070708" \
  --border hidden \
  --align center \
  --width 50 \
  --margin "1 2" \
  --padding "2 4" \
  $(gum style --bold $(./lib/gradient_color.sh "GeminiSH" 255 0 0 0 0 255)) \
  'Developed by: Amirali Toori' \
  $(gum style --bold $(./lib/gradient_color.sh "GitHub:@AmiraliToori" 0 248 242 65 195 0)) \
  "Current model: $model" >&2

gum choose --header "The Menu:" "Prompt" "Choose a model" "History" "Exit"
