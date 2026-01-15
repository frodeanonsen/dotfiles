#!/usr/bin/env bash
cd ~/.dotfiles || exit

if [ "$1" = "--flake" ]; then
	nix flake update
fi

if [ "$1" = "--repair" ]; then
	echo "Verifying and repairing store..."
	sudo nix-store --verify --check-contents --repair
	exit 0
fi

if [ "$1" = "--optimize" ]; then
	echo "Optimizing store..."
	sudo nix-store --optimise
	exit 0
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
