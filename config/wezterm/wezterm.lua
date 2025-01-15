local wezterm = require("wezterm")
local act = wezterm.action

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

wezterm.log_level = "debug"
-- After restarting WezTerm:
-- $HOME/.local/share/wezterm/logs/ (on Linux/macOS)

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

return {
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	enable_tab_bar = true,
	-- font = wezterm.font("Monaspace Xenon", {}),
	-- font_rules = {
	-- 	-- normal-intensity-and-italic
	-- 	{
	-- 		intensity = "Normal",
	-- 		italic = true,
	-- 		font = wezterm.font_with_fallback({
	-- 			family = "Monaspace Radon",
	-- 			weight = "SemiWide ExtraLight",
	-- 			italic = true,
	-- 		}),
	-- 	},
	-- },

	warn_about_missing_glyphs = true,

	font_size = 16.0,

	font = wezterm.font({ -- Normal text
		family = "Monaspace Xenon",
		harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
		stretch = "UltraCondensed", -- This doesn't seem to do anything
	}),

	font_rules = {
		{ -- Italic
			intensity = "Normal",
			italic = true,
			font = wezterm.font({
				family = "Monaspace Radon", -- script style
				-- family='Monaspace Xenon', -- courier-like
				style = "Italic",
			}),
		},

		{ -- Bold
			intensity = "Bold",
			italic = false,
			font = wezterm.font({
				-- family='Monaspace Krypton',
				family = "Monaspace Krypton",
				-- weight='ExtraBold',
				weight = "Bold",
			}),
		},

		{ -- Bold Italic
			intensity = "Bold",
			italic = true,
			font = wezterm.font({
				family = "Monaspace Xenon",
				style = "Italic",
				weight = "Bold",
			}),
		},
	},

	macos_window_background_blur = 50,
	window_background_opacity = 1.00,
	window_decorations = "RESIZE",
	leader = { key = "w", mods = "CTRL" },
	keys = {
		{
			key = "l",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "m",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},
		{
			key = "/",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "q",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "c", mods = "LEADER", action = act({ SpawnCommandInNewTab = { cwd = wezterm.home_dir } }) },
		{
			key = "a",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "activate_pane",
				timeout_milliseconds = 1000,
			}),
		},
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},
	},
	key_tables = {
		-- Defines the keys that are active in our resize-pane mode.
		-- Since we're likely to want to make multiple adjustments,
		-- we made the activation one_shot=false. We therefore need
		-- to define a key assignment for getting out of this mode.
		-- 'resize_pane' here corresponds to the name="resize_pane" in
		-- the key assignments above.
		resize_pane = {
			{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

			{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

			{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

			{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
			{ key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },

			-- Cancel the mode by pressing escape
			{ key = "Escape", action = "PopKeyTable" },
		},

		-- Defines the keys that are active in our activate-pane mode.
		-- 'activate_pane' here corresponds to the name="activate_pane" in
		-- the key assignments above.
		activate_pane = {
			{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
			{ key = "h", action = act.ActivatePaneDirection("Left") },

			{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
			{ key = "l", action = act.ActivatePaneDirection("Right") },

			{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
			{ key = "k", action = act.ActivatePaneDirection("Up") },

			{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
			{ key = "j", action = act.ActivatePaneDirection("Down") },
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
