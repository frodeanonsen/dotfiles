#!/usr/bin/env bash
cd ~/.dotfiles || exit

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	echo "Usage: scripts/update_zygbook.sh [--help] [--flake|--repair|--optimize|--gc]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --flake      Update flake inputs, then rebuild"
	echo "  --repair     Verify and repair the Nix store"
	echo "  --optimize   Optimize the Nix store"
	echo "  --gc         Run nix garbage collection"
	echo
	echo "Without options, rebuilds MacBookApple with darwin-rebuild switch."
	exit 0
fi

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

if [ "$1" = "--gc" ]; then
	echo "Collecting garbage..."
	sudo nix-collect-garbage -d
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
