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
M.lsp.signature = false
M.mason.command = true

M.ui = {
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
  tabufline = {
    lazyload = true,
  },
}
M.nvdash = {
  load_on_startup = false,
}

return M
