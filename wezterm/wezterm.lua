local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 16
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 1.0
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
