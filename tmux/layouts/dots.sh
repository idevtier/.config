#!/usr/bin/env bash
session_name="dots"
tmux send-keys -t "$session_name":1 "cd $HOME/.config; n -H" Enter
