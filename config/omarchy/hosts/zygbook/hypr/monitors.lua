-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_monitor_scale = "auto"
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- GDK_SCALE is one value for every screen and only sizes X11 (XWayland)
-- apps, which omarchy leaves unscaled. GTK only takes whole numbers; 1, as on
-- homebook, is the nearest to the Philips' 1.25, the screen in use at work, and
-- draws them a little small there and half size on the panel alone. Omarchy's
-- stock 2 suits the panel and makes them oversized on the Philips.
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Built-in panel at omarchy's stock scale 2: 3456x2234 is 1728x1117
-- logical, both integers as Hyprland requires.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2 })

-- Philips 499P9 ultrawide at work, to the right of the panel. Its EDID names
-- 3840x1080 as the preferred mode, so the catch-all above left it there;
-- highres picks 5120x1440 at the best refresh the link offers (70Hz over
-- USB-C here). Matched by EDID description without the serial, which covers
-- the work screen (AU02212018470) and the identical one at home on whatever
-- port either lands on. Scale 1.25 rather than homebook's 1, for larger text:
-- 4096x1152 logical, both integers as Hyprland requires. See homebook's
-- monitors.lua for the OSD USB-C setting that decides whether 5120x1440@60 is
-- offered.
hl.monitor({ output = "desc:Philips Consumer Electronics Company PHL 499P9", mode = "highres", position = "1728x0", scale = 1.25 })

-- Same column tuning as homebook. Dwindle splits while a window is wider than
-- 0.86 times its height: on the Philips at 4096x1152 logical (about 1126 tall
-- under the bar) columns go 4096, 2048, 1024, 512, and 1024 against a limit of
-- about 968 still splits, so four columns before windows stack, as on
-- homebook. Scrolling columns are a quarter of the screen, about 1000px.
hl.config({ dwindle = { split_width_multiplier = 0.86 } })
hl.config({
  scrolling = {
    column_width = 0.245,
    explicit_column_widths = "0.245, 0.333, 0.49, 0.667, 1.0",
  },
})
