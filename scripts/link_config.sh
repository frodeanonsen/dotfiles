#!/usr/bin/env bash
# Symlinks the tool configs in config/ into ~/.config.
#
# This machine (omarchy) does not use nix, so the links that
# linux/*-configuration.nix declares via home.file are made here instead.
set -eu

dotfiles="${DOTFILES:-$HOME/.dotfiles}"
src_dir="$dotfiles/config"
dst_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_dir="$dst_dir/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

# <name in ~/.config>:<dir under config/>
#
# Only real XDG config dirs belong here. The other config/* dirs are shell
# topic dirs (aliases.zsh, env.fish, ...) sourced straight from $DOTFILES by
# zsh/zshrc and fish/conf.d/config.fish, and macos-only tools (aerospace,
# sketchybar, skhd, yabai, iterm) have no target on linux.
#
# Deliberately absent: alacritty, ghostty, kitty. Not in use on this host,
# and the live omarchy versions of those are the ones that work here.
links="
atuin:atuin
fish:fish
lazygit:lazygit
nix:nix
nvim:lazyvim
ohmyposh:ohmyposh
starship:starship
tmux:tmux
toolkit:toolkit
wezterm:wezterm
zed:zed
zellij:zellij
"

# <path under $HOME>:<path under config/>
#
# Single files linked straight into $HOME, for tools that keep runtime state
# next to their config. ~/.claude also holds history, sessions and
# credentials, so linking the whole dir would drag that into the repo.
#
# ~/.config/hypr is omarchy's dir: it also holds files omarchy owns and
# rewrites (hyprsunset.conf, xdph.conf, upgrade backups), so only the user
# override files that hyprland.lua requires are linked, one by one.
# The omarchy/bin scripts are what those hypr bindings call; they go into
# ~/.local/bin, which omarchy already puts on PATH. The timed theme switch
# runs from systemd user units; scripts/bootstrap_omarchy.sh enables the ones
# listed in omarchy/units.
# omarchy/applications holds web app launchers that would otherwise be
# created by `omarchy webapp install`, with their icons in omarchy/icons.
# The icloud-mail launcher declares the mailto mime type;
# scripts/bootstrap_omarchy.sh makes it the default handler.
# omarchy/shell.json is the omarchy shell's user config (bar layout, idle
# lock and screensaver timeouts). The shell also writes to it, from
# `omarchy bar` and its settings panel; it saves through the symlink, so those
# changes show up in the repo as a diff.
# omarchy/XCompose is the compose table; it pulls in keyd's unicode sequences,
# which the per-host keyd config (Alt+a = å) needs to produce a character.
# omarchy/plugins holds user plugins for the omarchy shell, linked one dir per
# plugin. frode.battery-suspend suspends after 15 minutes of idle on battery;
# frode.display-off turns the displays off after 5 minutes of idle in place of
# the screensaver. Each is switched on by its entry in shell.json's plugins list.
# vivaldi-stable.conf is the flags file Vivaldi's launcher reads;
# ~/.config/vivaldi itself is the browser profile and stays out of the repo.
home_links="
.claude/settings.json:claude/settings.json
.claude/statusline.sh:claude/statusline.sh
.config/omarchy/themed/starship.toml.tpl:omarchy/themed/starship.toml.tpl
.config/omarchy/shell.json:omarchy/shell.json
.config/omarchy/plugins/frode.battery-suspend:omarchy/plugins/frode.battery-suspend
.config/omarchy/plugins/frode.display-off:omarchy/plugins/frode.display-off
.config/hypr/hyprland.lua:hypr/hyprland.lua
.config/hypr/input.lua:hypr/input.lua
.config/hypr/bindings.lua:hypr/bindings.lua
.config/hypr/looknfeel.lua:hypr/looknfeel.lua
.config/hypr/autostart.lua:hypr/autostart.lua
.local/bin/theme-mode-toggle:omarchy/bin/theme-mode-toggle
.local/bin/clamshell-follow:omarchy/bin/clamshell-follow
.config/systemd/user/theme-mode-auto.service:omarchy/systemd/user/theme-mode-auto.service
.config/systemd/user/theme-mode-auto.timer:omarchy/systemd/user/theme-mode-auto.timer
.local/share/applications/icloud-mail.desktop:omarchy/applications/icloud-mail.desktop
.local/share/icons/hicolor/256x256/apps/icloud-mail.png:omarchy/icons/icloud-mail.png
.config/vivaldi-stable.conf:vivaldi/vivaldi-stable.conf
.XCompose:omarchy/XCompose
"

# What only one machine should get is in omarchy/hosts/<hostname>/home_links,
# same format, # comments allowed: hypr/monitors.lua, which names that
# machine's panel and outputs, and links for hardware quirks such as
# homebook's bt-autoreconnect. A host without that file gets the shared links
# only. DOTFILES_HOST overrides the hostname, for a dry run of another host.
host="${DOTFILES_HOST:-$(hostname)}"
host_links_file="$src_dir/omarchy/hosts/$host/home_links"
host_links=""
if [ -f "$host_links_file" ]; then
	host_links=$(sed -e 's/#.*//' -e 's/[[:space:]]//g' "$host_links_file" | grep -v '^$' || true)
fi

dry_run=false
force=false

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
	echo "Usage: scripts/link_config.sh [--help] [--dry-run] [--force]"
	echo
	echo "Options:"
	echo "  --help, -h   Show this help message"
	echo "  --dry-run    Report what would change, touch nothing"
	echo "  --force      Replace existing files, backing them up first"
	echo
	echo "Without --force, anything already present in ~/.config that is not"
	echo "already the right symlink is left alone and reported as a conflict."
	echo "Backups go to \$XDG_CONFIG_HOME/.dotfiles-backup/<timestamp>/."
	exit 0
fi

for arg in "$@"; do
	case "$arg" in
	--dry-run) dry_run=true ;;
	--force) force=true ;;
	*)
		echo "unknown option: $arg" >&2
		echo "try: scripts/link_config.sh --help" >&2
		exit 1
		;;
	esac
done

linked=0
skipped=0
conflicts=0

# Moves an existing path aside into the timestamped backup dir.
back_up() {
	target="$1"
	if [ "$dry_run" = true ]; then
		echo "    would back up to $backup_dir/$(basename "$target")"
		return
	fi
	mkdir -p "$backup_dir"
	mv "$target" "$backup_dir/"
	echo "    backed up to $backup_dir/$(basename "$target")"
}

make_link() {
	src="$1"
	target="$2"
	if [ "$dry_run" = true ]; then
		echo "    would link $target -> $src"
		return
	fi
	ln -s "$src" "$target"
	echo "    linked $target -> $src"
}

[ "$dry_run" = true ] && echo "dry run, nothing will be changed"
echo "$src_dir -> $dst_dir"
echo

[ "$dry_run" = true ] || mkdir -p "$dst_dir"

# Links $2 -> $1, handling the already-linked, in-the-way and
# identical-content cases. Works for both dirs and single files.
link_one() {
	src="$1"
	target="$2"

	if [ ! -e "$src" ]; then
		echo "    MISSING source $src, skipping"
		conflicts=$((conflicts + 1))
		return
	fi

	# Already pointing where we want it.
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		echo "    ok, already linked"
		skipped=$((skipped + 1))
		return
	fi

	[ "$dry_run" = true ] || mkdir -p "$(dirname "$target")"

	# A link into the repo that points somewhere else is one of ours from
	# before the source moved; repoint it, there is nothing to back up.
	if [ -L "$target" ]; then
		case "$(readlink "$target")" in
		"$dotfiles"/*)
			echo "    stale link to $(readlink "$target"), relinking"
			[ "$dry_run" = true ] || rm "$target"
			make_link "$src" "$target"
			linked=$((linked + 1))
			return
			;;
		esac
	fi

	# Nothing in the way. A dangling symlink counts as in the way, hence -L.
	if [ ! -e "$target" ] && [ ! -L "$target" ]; then
		make_link "$src" "$target"
		linked=$((linked + 1))
		return
	fi

	# Identical content is not worth a backup or a prompt.
	if [ ! -L "$target" ] && diff -r "$target" "$src" >/dev/null 2>&1; then
		echo "    identical content, converting to symlink"
		[ "$dry_run" = true ] || rm -rf "$target"
		make_link "$src" "$target"
		linked=$((linked + 1))
		return
	fi

	if [ "$force" = false ]; then
		echo "    CONFLICT: $target exists and differs, left alone"
		echo "    diff -ru '$target' '$src'"
		echo "    re-run with --force to replace it"
		conflicts=$((conflicts + 1))
		return
	fi

	back_up "$target"
	make_link "$src" "$target"
	linked=$((linked + 1))
}

for entry in $links; do
	name="${entry%%:*}"
	source_name="${entry##*:}"
	echo "$name"
	link_one "$src_dir/$source_name" "$dst_dir/$name"
done

for entry in $home_links; do
	name="${entry%%:*}"
	source_name="${entry##*:}"
	echo "~/$name"
	link_one "$src_dir/$source_name" "$HOME/$name"
done

if [ -n "$host_links" ]; then
	echo
	echo "host $host"
else
	echo
	echo "host $host: no $host_links_file, shared links only"
fi
for entry in $host_links; do
	name="${entry%%:*}"
	source_name="${entry##*:}"
	echo "~/$name"
	link_one "$src_dir/$source_name" "$HOME/$name"
done

echo
echo "$linked linked, $skipped already correct, $conflicts conflicts"

if [ "$conflicts" -gt 0 ] && [ "$force" = false ]; then
	echo "resolve the conflicts above, or re-run with --force"
	exit 1
fi
