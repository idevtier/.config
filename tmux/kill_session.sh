#!/bin/env bash
session_to_kill=`tmux list-sessions | fzf | sed 's/:.*$//'`
tmux kill-session -t $session_to_kill
