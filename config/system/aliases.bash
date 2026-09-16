# Port of config/fish/conf.d/aliases.fish. Tool swaps are guarded so a missing
# tool leaves the original command alone.
alias cls='clear'

if command -v eza >/dev/null 2>&1; then
	alias l='eza -l --icons --git --group-directories-first --time-style=long-iso'
	alias ll='eza -l --icons --git --group-directories-first --time-style=long-iso'
	alias la='eza -l --icons --git -a --group-directories-first --time-style=long-iso'
	alias lt='eza --tree --level=2 --icons --git -a --group-directories-first --time-style=long-iso'
	alias lastmod='eza -l -t modified -s newest -r --icons --git --time-style=long-iso --recurse | head -n 10'
fi

command -v dust >/dev/null 2>&1 && alias du=dust
command -v doggo >/dev/null 2>&1 && alias dig=doggo
command -v xh >/dev/null 2>&1 && alias http=xh
command -v duf >/dev/null 2>&1 && alias df=duf
command -v btm >/dev/null 2>&1 && alias top=btm
command -v mise >/dev/null 2>&1 && alias m=mise
