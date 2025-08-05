function update_theme
    set mode (defaults read -g AppleInterfaceStyle 2>/dev/null)
    if test "$mode" = Dark
        printf "Setting theme to dark mode\n"
        fish_config theme choose tokyonight_night
    else
        printf "Setting theme to light mode\n"
        fish_config theme choose tokyonight_day
    end
end
