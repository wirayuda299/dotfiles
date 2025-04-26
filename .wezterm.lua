local wezterm = require "wezterm"
local config = wezterm.config_builder()

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)
config.font = wezterm.font "Jetbrains Mono"
config.font_size = 14

config.window_background_image = wezterm.home_dir .. "/Pictures/wallpapers/blur.jpg"
config.window_background_image_hsb = {
  brightness = 0.088,
  hue = 1.0,
  saturation = 1.0,
}
config.window_background_opacity = 1
config.text_background_opacity = 1.0

config.enable_tab_bar = false
config.window_decorations = "NONE"
config.enable_tab_bar = false -- <= ini penting buat ilangin header

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.adjust_window_size_when_changing_font_size = false

return config
