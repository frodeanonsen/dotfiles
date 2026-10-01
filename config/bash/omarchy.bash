# Sourced from ~/.bashrc on omarchy hosts, after omarchy's own rc chain.
# Omarchy stays the base; this layers the repo's bash config on top.
#
# Mirrors what config/fish/conf.d/config.fish does for fish: every
# config/*/*.bash topic file is sourced from here, path files first, then
# everything else, completion files last. Adding a foo/aliases.bash is all it
# takes to get it loaded.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

_dotfiles_bash_files=("$DOTFILES"/config/*/*.bash)

for _f in "${_dotfiles_bash_files[@]}"; do
	case "$_f" in */path.bash) source "$_f" ;; esac
done

for _f in "${_dotfiles_bash_files[@]}"; do
	case "$_f" in
	*/path.bash | */completion.bash | */omarchy.bash) ;;
	*) source "$_f" ;;
	esac
done

for _f in "${_dotfiles_bash_files[@]}"; do
	case "$_f" in */completion.bash) source "$_f" ;; esac
done

unset _f _dotfiles_bash_files

# Hand interactive shells over to fish. The login shell stays bash: omarchy's
# session start (uwsm, /etc/profile.d, ~/.bash_profile) expects it, and a fish
# login shell leaves a black screen after the LUKS prompt (omarchy #2487).
# Everything above has run by now, so fish inherits omarchy's env. Running
# `bash` from fish stays in bash, and so does `bash -c` / scripts.
if [[ $- == *i* && -z ${BASH_EXECUTION_STRING} ]] && command -v fish >/dev/null 2>&1 &&
	[[ $(ps --no-header --pid=$PPID --format=comm) != fish ]]; then
	shopt -q login_shell && exec fish --login
	exec fish
fi
