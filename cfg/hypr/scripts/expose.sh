#!/usr/bin/env bash

items=$(hyprctl workspaces -j | jq '.[] | select(.name == "special:exposed") | length')

[[ -z "$items" ]] && {
  pypr expose
} || {
  pypr expose
  hyprctl dispatch togglespecialworkspace exposed
}
