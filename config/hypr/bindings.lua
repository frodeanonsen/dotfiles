-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Toggle Catppuccin dark (Mocha) / light (Latte)
o.bind("SUPER + SHIFT + T", "Toggle dark/light theme", "~/.local/bin/theme-mode-toggle")

-- Vim-style window navigation. Move the defaults that lived on SUPER + J/K/L.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + E", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + I", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + Y", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

o.bind("SUPER + SHIFT + ALT + H", "Move window to left monitor", hl.dsp.window.move({ monitor = "-1" }))
o.bind("SUPER + SHIFT + ALT + L", "Move window to right monitor", hl.dsp.window.move({ monitor = "+1" }))

-- Email: iCloud Mail instead of HEY. Both keys are Omarchy defaults bound to
-- HEY. No "new email" binding: iCloud webmail has no compose URL to open.
-- With focus = true the description doubles as the window pattern (matched
-- against class and title of every open window), so it must be the web app's
-- window title "iCloud Mail"; a generic "Email" also matched any terminal
-- with "email" in its title and focused that instead.
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + ALT + E")
o.bind("SUPER + SHIFT + E", "iCloud Mail", { webapp = "https://www.icloud.com/mail/", focus = true })

-- Clamshell: show the laptop's workspace on the external monitor when the lid
-- closes. Runs alongside Omarchy's own lid handler.
o.bind("switch:on:Lid Switch", nil, "~/.local/bin/clamshell-follow", { locked = true })

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
