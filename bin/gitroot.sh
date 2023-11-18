#!/usr/bin/env bash
start_path="$PWD"
while :; do
	if [[ "$PWD" == "$HOME" ]]; then
		echo "Git root not found" 1>&2
		echo "$start_path"
		exit 1
	fi

	cd ..

	if [[ -d .git || -f .git ]]; then
		echo "$PWD"
		exit 0
	fi
done
