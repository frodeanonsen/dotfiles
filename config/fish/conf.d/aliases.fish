alias cls='clear' # Good 'ol Clear Screen command

# alias eza='nix run github:eza-community/eza -- $*'
alias l='eza -l --icons --git --group-directories-first --time-style=long-iso'
alias ll='eza -l --icons --git --group-directories-first --time-style=long-iso'
alias la='eza -l --icons --git -a --group-directories-first --time-style=long-iso'
alias lt='eza --tree --level=2 --icons --git -a --group-directories-first --time-style=long-iso'
alias lastmod='eza -l -t modified -s newest -r --icons --git --time-style=long-iso --recurse |head -n 10'

# Tool swaps are guarded so a missing tool leaves the original command alone
# (omarchy hosts lack some of them, and dog is doggo on Arch).
command -q dust; and alias du=dust

if command -q doggo
    alias dig=doggo
else if command -q dog
    alias dig=dog
end

command -q xh; and alias http=xh

command -q duf; and alias df=duf

command -q btm; and alias top=btm

test (uname) = Darwin; and alias lsusb='system_profiler SPUSBDataType'

command -q mise; and alias m=mise

command -q kubectl; and alias k=kubectl
