#!/usr/bin/env bash
set -e
cd "$1"
tmux neww -n 'LazyGit' bash -c lazygit
