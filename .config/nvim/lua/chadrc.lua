-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.colorify = {
  enabled = false,
}
M.lsp.signature = false
M.base46 = {
  transparency = true,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  integrations = {
    treesitter = {
      enabled = false,
    },
    alpha = { enabled = false },
    avante = { enabled = false },
    ---| "'blankline'"
    ---| "'blink'"
    ---| "'bufferline'"
    ---| "'cmp'"
    ---| "'codeactionmenu'"
    ---| "'dap'"
    ---| "'defaults'"
    ---| "'devicons'"
    ---| "'diffview'"
    ---| "'edgy'"
    ---| "'flash'"
    ---| "'git-conflict'"
    ---| "'git'"
    ---| "'grug_far'"
    ---| "'hop'"
    ---| "'leap'"
    ---| "'lsp'"
    ---| "'lspsaga'"
    ---| "'markview'"
    ---| "'mason'"
    ---| "'mini-tabline'"
    ---| "'navic'"
    ---| "'neogit'"
    ---| "'notify'"
    nvcheatsheet = { enabled = false },
    ---| "'nvimtree'"
    ---| "'nvshades'"
    ---| "'orgmode'"
    ---| "'rainbowdelimiters'"
    ---| "'render-markdown'"
    ---| "'semantic_tokens'"
    ---| "'statusline'"
    ---| "'syntax'"
    ---| "'tbline'"
    telescope = { enabled = false },
    ---| "'tiny-inline-diagnostic'"
    ---| "'todo'"
    ---| "'treesitter'"
    ---| "'trouble'"
    ---| "'vim-illuminate'"
    whichkey = { enabled = false },
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
    abbr_maxwidth = 80,
  },
}

return M
