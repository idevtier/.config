#!/usr/bin/env bash
session_name="dbrip"

tmux rename-window -t "$session_name:1" "nvim"
tmux send-keys -t "$session_name:1" "nvim src/main.rs" Enter

tmux new-window -t "$session_name:2" -c "#{pane_current_path}" -n "tauri dev"
tmux send-keys -t "$session_name:2" "cargo tauri dev" Enter

tmux next-window
