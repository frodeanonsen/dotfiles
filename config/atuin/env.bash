# Shell history via atuin. Ctrl-R opens the search; the up arrow is left to
# omarchy's readline prefix search (see default/bash/inputrc).
# atuin's bash hooks need bash-preexec (package bash-preexec).
if command -v atuin >/dev/null 2>&1; then
	export ATUIN_CONFIG_DIR="$HOME/.config/atuin"
	[ -f /usr/share/bash-preexec/bash-preexec.sh ] && source /usr/share/bash-preexec/bash-preexec.sh
	eval "$(atuin init bash --disable-up-arrow)"
fi
