alias cls='clear' # Good 'ol Clear Screen command

# alias eza='nix run github:eza-community/eza -- $*'
alias l='eza -l --icons --git --group-directories-first --time-style=long-iso'
alias ll='eza -l --icons --git --group-directories-first --time-style=long-iso'
alias la='eza -l --icons --git -a --group-directories-first --time-style=long-iso'
alias lt='eza --tree --level=2 --icons --git -a --group-directories-first --time-style=long-iso'
alias lastmod='eza -l -t modified -s newest -r --icons --git --time-style=long-iso --recurse |head -n 10'

alias du=dust

alias dig=dog

alias http=xh

alias df=duf

alias top='btop'

alias lsusb='system_profiler SPUSBDataType'
