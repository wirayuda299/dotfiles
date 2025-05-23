---@type ChadrcConfig
local M = {}

M.base46 = {
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  theme_toggle = {
    "onedark",
    "catppuccin",
  },
}
M.colorify = {
  enabled = false,
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  transparent = true,
  cmp = {
    icons = false,
    icons_left = false,
    format_colors = {
      lsp = true,
      icon = "",
    },
  },
  statusline = {
    separator_style = "arrow",
    theme = "minimal",
  },
}
M.nvdash = {
  load_on_startup = false,
}

return M
