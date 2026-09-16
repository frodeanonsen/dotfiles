# Starship prompt for omarchy hosts. Same two-line layout as
# config/starship/starship.toml, but every colour is an omarchy theme
# variable. Linked to ~/.config/omarchy/themed/, where `omarchy theme set`
# renders it to ~/.local/state/omarchy/current/theme/starship.toml; bash
# points STARSHIP_CONFIG there (see config/bash/omarchy.bash).

format = """
[░▒▓]({{ mix background accent 60% }})\
[  ](bg:{{ mix background accent 60% }} fg:{{ background }})\
[](bg:{{ accent }} fg:{{ mix background accent 60% }})\
$directory\
[](fg:{{ accent }} bg:{{ selection }})\
$git_branch\
$git_status\
[](fg:{{ selection }} bg:{{ mix background accent 12% }})\
$nodejs\
$rust\
$c\
$cmake\
[](fg:{{ mix background accent 12% }} bg:{{ darker_background }})\
$time\
[ ](fg:{{ darker_background }})\
\n$character"""

[directory]
style = "fg:{{ background }} bg:{{ accent }}"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:{{ selection }}"
format = '[[ $symbol $branch ](fg:{{ accent }} bg:{{ selection }})]($style)'

[git_status]
style = "bg:{{ selection }}"
format = '[[($all_status$ahead_behind )](fg:{{ accent }} bg:{{ selection }})]($style)'

[nodejs]
symbol = ""
style = "bg:{{ mix background accent 12% }}"
format = '[[ $symbol ($version) ](fg:{{ accent }} bg:{{ mix background accent 12% }})]($style)'

[rust]
symbol = ""
style = "bg:{{ mix background accent 12% }}"
format = '[[ $symbol ($version) ](fg:{{ accent }} bg:{{ mix background accent 12% }})]($style)'

[c]
symbol = "C"
style = "bg:{{ mix background accent 12% }}"
format = '[[ $symbol ($version) ](fg:{{ accent }} bg:{{ mix background accent 12% }})]($style)'

[cmake]
symbol = "△"
style = "bg:{{ mix background accent 12% }}"
format = '[[ $symbol ($version) ](fg:{{ accent }} bg:{{ mix background accent 12% }})]($style)'

[time]
disabled = false
time_format = "%R"                                      # Hour:Minute Format
style = "bg:{{ darker_background }}"
format = '[[  $time ](fg:{{ light_foreground }} bg:{{ darker_background }})]($style)'
