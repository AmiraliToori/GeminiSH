#!/usr/bin/env bash

function error_page {
  local error_text="$1"
  local loading_text="$2"
  clear >&2
  gum style \
    --background "#070708" \
    --border hidden \
    --bold \
    --border-foreground 212 \
    --width 50 \
    --margin "1 20" \
    --padding "1 2" \
    --align center \
    --foreground "#E40406" \
    " $error_text " >&2

  gum spin --spinner="dot" \
    --align="left" \
    --title "$loading_text" \
    -- sleep 3 >&2
  clear >&2
}
