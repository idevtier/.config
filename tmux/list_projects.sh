#!/usr/bin/env bash
set -e
BASE_DIR=$1
cd "$BASE_DIR" >/dev/null
fd --regex '^(.git|.bare)$' --type d --hidden | xargs dirname
