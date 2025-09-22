#!/usr/bin/env bash
cd ~/.dotfiles || exit

if [ "$1" = "--flake" ]; then
	nix flake update
fi

retries=0
max_retries=10
while ! sudo darwin-rebuild switch --flake .#MacBookApple; do
	retries=$((retries + 1))
	if [ "$retries" -ge "$max_retries" ]; then
		echo "Reached maximum retries, exiting."
		exit 1
	fi
	echo "running again"
done
