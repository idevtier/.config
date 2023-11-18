#!/usr/bin/env bash

session_name="music"
window=${session_name}:0

tmux kill-session -t $session_name
tmux new -s $session_name -d
tmux send -t music:1 "python3 ~/.config/tmux/music_player_core.py" Enter
tmux switch -t $session_name
if command -v cava &> /dev/null
then
    tmux split-window -t music:.1
    tmux select-pane -t music:.1
    tmux send -t music:.2 'cava' Enter
fi
