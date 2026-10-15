-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel (Apple LCD) on the left, ultrawide external on the right.
-- Restored from the pre-Lua hyprland.conf.
-- At scale 1.5 the laptop panel is 1920x1200 logical, so the ultrawide starts at x=1920.
-- (2880/1.5 and 1800/1.5 are both integers, which Hyprland requires.)
hl.monitor({ output = "eDP-1", mode = "2880x1800@60", position = "0x0", scale = 1.5 })
-- Philips 499P9 ultrawide, matched by EDID description because the port name
-- has moved (DP-6, then DP-4) and the catch-all left it at 3840x1080 @1.25.
-- Over USB-C the OSD "USB Setting > USB-C Setting" decides the DP lane count:
-- "High Data Speed" (USB 3) leaves two lanes and the EDID only offers
-- 5120x1440@30; "High Resolution" (USB 2) gives four lanes and 5120x1440@60.
-- highres picks 60Hz automatically whenever the monitor advertises it.
hl.monitor({ output = "desc:Philips Consumer Electronics Company PHL 499P9 AU02105001407", mode = "highres", position = "1920x0", scale = 1 })

-- Samsung S27A850 (2560x1440) over the HP USB-C to DP adapter, matched by
-- EDID description so it gets the same rule on whichever port it lands on.
-- highres picks 2560x1440@60 when the link trained at HBR and falls back to
-- 1280x1024 if it only trained at RBR. If it comes up at 1280x1024, replug
-- the adapter; the link verified at RBR once at plug-in but re-verifies at
-- HBR on a hotplug (amdgpu debugfs DP-4/trigger_hotplug does the same).
hl.monitor({ output = "desc:Samsung Electric Company SMS27A850 H1AK500000", mode = "highres", position = "1920x0", scale = 1 })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Dwindle splits the focused window side by side when its width exceeds its
-- height times split_width_multiplier, so the number of columns a screen
-- gets before windows start stacking depends on these monitors' shapes.
-- Philips at 5120x1414 logical: columns go 5120, 2560, 1280, 640. At the
-- default 1.0 a 1280 column stacks, giving three columns; 0.86 lets it split
-- once more and stacks only from 640, giving four. The laptop panel at
-- 1920x1174 logical hits 960 (ratio 0.82) after one split and keeps stacking
-- at two columns. Anything from 0.83 to 0.90 gives the same result.
hl.config({ dwindle = { split_width_multiplier = 0.86 } })

-- Scrolling layout: new columns take a quarter of the Philips (about 1250px
-- of 5120), so four fit side by side and the fifth scrolls. Stock 0.49 fits
-- two. The setting is global, so on the laptop panel alone a column is only
-- about 470px wide. SUPER + ] and SUPER + [ (bindings.lua) step the focused
-- column through explicit_column_widths.
hl.config({
  scrolling = {
    column_width = 0.245,
    explicit_column_widths = "0.245, 0.333, 0.49, 0.667, 1.0",
  },
})
