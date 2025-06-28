#!/usr/bin/env bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GEMINI_API_KEY" |
  jq -r '.models[].name' 2>/dev/null |
  awk -F/ '{print $2}' || printf "API Key not set or Invalid" && exit 1
