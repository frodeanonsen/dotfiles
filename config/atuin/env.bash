# Shell history via atuin. Ctrl-R opens the search; the up arrow is left to
# omarchy's readline prefix search (see default/bash/inputrc).
# atuin's bash hooks need bash-preexec; `atuin init` bundles its own copy, which
# copes with an array PROMPT_COMMAND and hooks preexec through PS0. Do not source
# the bash-preexec package first: 0.6.0 only cleans PROMPT_COMMAND[0], and wins
# over the bundled one.
if command -v atuin >/dev/null 2>&1; then
	export ATUIN_CONFIG_DIR="$HOME/.config/atuin"
	eval "$(atuin init bash --disable-up-arrow)"
fi
