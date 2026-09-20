-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel (Apple LCD) on the left, ultrawide external on the right.
-- Restored from the pre-Lua hyprland.conf.
-- At scale 2 the laptop panel is 1440px wide, so DP-6 starts at x=1440.
hl.monitor({ output = "eDP-1", mode = "2880x1800@60", position = "0x0", scale = 2 })
-- highres: the current link only offers 5120x1440@30, but this picks 60Hz
-- automatically if the cable/port/monitor setting ever offers it again.
hl.monitor({ output = "DP-6", mode = "highres", position = "1440x0", scale = 1 })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
