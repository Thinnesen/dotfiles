local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Look
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.line_height = 1.1

-- "Transparent to the wallpaper only": macOS can't composite past other
-- windows, so we draw a dimmed copy of the wallpaper as the background
-- instead. Refresh the copy after changing wallpaper (see README).
-- Falls back to real translucency on machines without the copy.
local wallpaper = wezterm.home_dir .. "/.local/share/wezterm/background.png"
local f = io.open(wallpaper, "r")
if f then
	f:close()
	config.background = {
		{
			source = { File = wallpaper },
			width = "Cover",
			height = "Cover",
			horizontal_align = "Center",
			vertical_align = "Middle",
		},
		-- Dark glass over the wallpaper; raise opacity for a stronger
		-- terminal, lower it to let more wallpaper through.
		{
			source = { Color = "#232136" }, -- rose-pine-moon base
			width = "100%",
			height = "100%",
			opacity = 0.85,
		},
	}
else
	config.window_background_opacity = 0.8
	config.macos_window_background_blur = 50
end

-- Chrome: no title bar clutter, no tab bar until you need it
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }

-- Smoothness
config.max_fps = 120
config.animation_fps = 120
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.default_cursor_style = "BlinkingBar"
config.audible_bell = "Disabled"

return config
