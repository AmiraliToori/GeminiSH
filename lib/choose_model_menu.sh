#!/usr/bin/env bash

source ./lib/utils.sh
current_model="$1"

clear >&2
export -f generate_models_list
export GEMINI_API_KEY

selected_model=$(gum choose $(gum spin \
  --spinner="line" \
  --title="Fetching..." \
  -- bash -c 'generate_models_list'))
if [[ -z $selected_model ]] || [[ $selected_model == "nothing selected" ]]; then
  error_page "No model selected. Please try again."
  printf "$current_model"
else
  gum style --foreground="33" \
    --underline \
    --padding "1 1" \
    --align "center" \
    "You have been selected: $selected_model" >&2 && sleep 2
  printf "$selected_model"

fi
