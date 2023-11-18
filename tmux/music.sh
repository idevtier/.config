#!/usr/bin/env bash
set -e

session_name="music"
playlist_path="$HOME/notes/music.norg"

track=$(rg -e '- ' "$playlist_path" | sed -r 's/\-\s\{(.*)\}\[(.*)\]/\2 :::: \1/' | fzf | sed -r 's/.*:::: (.*)/\1/')
if [[ -z "$track" ]]; then
	exit 1
fi

if tmux has-session -t "$session_name"; then
	tmux kill-session -t "$session_name"
fi

tmux new-session -s "$session_name" -d
tmux set -t "$session_name" status off

tmux send-keys -t "$session_name:1" "mpv $track --input-ipc-server=/tmp/mpvsocket --no-video" Enter
notify-send "Starting mpv"

tmux new-window -t "$session_name:2" -c "#{pane_current_path}" -n "Cava"
tmux send-keys -t "$session_name:2" "cava" Enter
