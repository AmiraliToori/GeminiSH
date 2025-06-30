#!/usr/bin/env bash

color_palette="Default"
BACKGROUND_COLOR="#1E1F29" #Deep Inn black
FOREGROUND_COLOR="#E0E7EB" #Light Gray
ERROR_COLOR="#EF6B6B"      #Error Red

function default_colors() {
  PRIMARY_COLOR="#5B9CFF"   #Gemini Blue
  SECONDARY_COLOR="#A084E8" #Celestial Violet
}

function gum_colors() {
  exit 0
}

if (($# == 1)); then
  color_palette="$1"
fi

case "$color_palette" in
"Default") default_colors ;;
"Gum") gum_colors ;;
esac
