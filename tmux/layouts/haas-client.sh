#!/usr/bin/env bash
session_name="haas-client"
tmux send-keys -t "$session_name":1 'cd ../../server && docker compose up -d && notify-send "Haas server started" && docker compose logs --tail=100 -f' Enter

tmux new-window -t "$session_name":2 -c "#{pane_current_path}" -n "Editor"
tmux send-keys -t "$session_name":2 'nvim src/main.rs' Enter

tmux new-window -t "$session_name":3 -n -c "#{pane_current_path}" "Terminal"

tmux next-window
