#!/bin/bash

# Change volume by argument, e.g. +5% or -5%
pactl set-sink-volume @DEFAULT_SINK@ "$1"

# Get current volume percentage (first channel)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

# Notify ID to replace previous notification
notify_id=9999

# Show notification (replace previous one with same ID)
notify-send --replace-id=$notify_id "Volume: $vol"
