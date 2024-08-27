alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command

alias ll='eza -l --icons --git --group-directories-first --time-style=long-iso'
alias la='eza -l --icons --git -a --group-directories-first --time-style=long-iso'
alias lt='eza --tree --level=2 --icons --git -a --group-directories-first --time-style=long-iso'
alias lastmod='find . -type f -not -path "*/\.*" -exec eza -lrt modified --icons --git --group-directories-first --time-style=long-iso {} + | head -n 10'

alias du=dust

alias dig=dog

alias http=xh

alias df=duf

alias cat='bat -p'
