#!/usr/bin/env sh
cd ~/.dotfiles || exit

if [ "$1" = "--flake" ]; then
	nix flake update
fi

retries=0
max_retries=10
while ! home-manager switch --flake .#ZygizoOne; do
	retries=$((retries + 1))
	if [ "$retries" -ge "$max_retries" ]; then
		echo "Reached maximum retries, exiting."
		exit 1
	fi
	echo "running again"
done
