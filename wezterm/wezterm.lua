-- WezTerm config for native Linux (Debian/Ubuntu). Needs "IosevkaTerm Nerd Font" (installed by install.sh).
local wezterm = require 'wezterm'
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.font = wezterm.font('IosevkaTerm Nerd Font')
config.font_size = 11.0
config.window_background_opacity = 1.0
config.colors = { background = '#0d0e14' }
config.initial_cols = 200
config.initial_rows = 32
-- config.front_end = "OpenGL" -- Uncomment if you hit graphics problems

return config
