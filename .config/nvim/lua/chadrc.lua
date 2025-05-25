-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.colorify = {
  enabled = false,
}
M.base46 = {
  theme = "onedark",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = { load_on_startup = false }
M.ui = {
  tabufline = {
    enabled = false,
  },
  cmp = {
    icons = false,
    format_colors = {
      icon = "",
      lsp = false,
    },
  },
}

return M
