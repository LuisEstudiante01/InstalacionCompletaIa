-- Reference config for WezTerm on WINDOWS opening a WSL distro.
-- Copy to %USERPROFILE%\.wezterm.lua and change 'WSL:Ubuntu' to your distro (see: wsl -l).
local wezterm = require 'wezterm'
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font('IosevkaTerm Nerd Font')
config.font_size = 11.0
config.window_background_opacity = 1.0
config.colors = { background = '#0d0e14' }
config.initial_cols = 200
config.initial_rows = 32

wezterm.on('gui-startup', function(cmd)
  local args = cmd or {}
  args.width = 200
  args.height = 32
  args.domain = { DomainName = 'WSL:Ubuntu' }
  wezterm.mux.spawn_window(args)
end)

return config
