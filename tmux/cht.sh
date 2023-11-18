#!/usr/bin/env bash

languages=$(echo "js python java rust bash" | tr ' ' '\n')

selected=$(printf '%s' "$languages" | fzf)
read -rp "query: " query

query=$(echo "$query" | tr ' ' '+')
tmux neww bash -c "curl cht.sh/$selected/$query | batcat"
