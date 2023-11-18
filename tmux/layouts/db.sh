#!/usr/bin/env bash
set -e

session_name="db"
cd "$HOME"

tmux rename-window -t "$session_name:1" "port-forward"
tmux send-keys -t "$session_name:1" "ssh -N -L 5435:94.130.201.172:5432 cloud4" Enter

tmux new-window -t "$session_name:2" -n "database"
tmux send-keys -t "$session_name:2" "nvim -c DBUI" Enter
