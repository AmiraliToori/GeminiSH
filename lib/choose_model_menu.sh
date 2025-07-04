#!/usr/bin/env bash

source ./lib/error_page.sh
current_model="$1"

clear >&2
selected_model=$(gum choose $(./lib/models_list.sh))
if [[ -z $selected_model ]] || [[ $selected_model == "nothing selected" ]]; then
  error_page "No model selected. Please try again." "Loading"
  printf "$current_model"
else
  printf "$selected_model"
  gum style "You have been selected: $selected_model" >&2
fi
