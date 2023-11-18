#!/usr/bin/env bash

PROJECTS_BASE_DIR="$HOME/code"
LIST_SESSIONS="${1:-$HOME/.config/tmux/list_sessions.sh}"
LIST_PROJECTS="${2:-$HOME/.config/tmux/list_projects.sh}"

select_session() {
    "$HOME/.config/tmux/list_sessions.sh" | fzf --reverse \
	--prompt 'Session> ' \
	--print-query \
	--header '<C-s>: [S]essions / <C-o>: Pr[O]jects / <C-d>: kill session' \
	--bind "ctrl-s:change-prompt(Session> )+reload($LIST_SESSIONS)" \
	--bind "ctrl-o:change-prompt(Project> )+reload($LIST_PROJECTS $PROJECTS_BASE_DIR)" \
	--bind "ctrl-d:reload(tmux kill-session -t {}; $LIST_SESSIONS)+clear-query"
}

sessions=$(select_session)
retval=$?

IFS=$'\n' read -rd '' -a sess_arr <<<"$sessions"

session_name=${sess_arr[1]}
query=${sess_arr[0]}

if [[ -z "$query" ]]; then
    exit 1
fi

echo "Query: $query, Session: $session_name"

if [ $retval == 0 ]; then
    if [ "$session_name" == "" ]; then
	session_name="$query"
    fi
else
    session_name="$query"
fi

if [[ "$session_name" == https* ]]; then
    echo "personal learn work/pixelplex work/haas" | tr ' ' | fzf
fi

session_path=$HOME

if [[ -d "$PROJECTS_BASE_DIR/$session_name" ]]; then
    session_path="$PROJECTS_BASE_DIR/$session_name"
    session_name=$(basename "$session_name")
fi

if [ ! "$(tmux has-session -t "$session_name" 2>/dev/null)" ]; then
    tmux new-session -d -s "$session_name" -c "$session_path"
fi

tmux switch-client -t "$session_name"

# Run layout if exists
base_layout_path="$HOME/.config/tmux/layouts"
layout=$(cd "$base_layout_path" && fd "$session_name.sh")
if [[ -z "$layout" ]]; then
    exit 0
fi

"$base_layout_path/$layout"
