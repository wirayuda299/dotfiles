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
    treesitter = { enabled = false },
    alpha = { enabled = false },
    avante = { enabled = false },
    cmp = { enabled = false },
    nvimtree = { enabled = false },
    bufferline = { enabled = false },
    blankline = { enabled = false },
    blink = { enabled = false },

    ---| "'blankline'"
    ---| "'blink'"
    ---| "'bufferline'"
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
    lsp = { enabled = false },
    mason = { enabled = false },
    ---| "'lspsaga'"
    ---| "'markview'"
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
    -- "tiny-inline-diagnostic"={enabled=false},
    ---| "'todo'"
    ---| "'trouble'"
    ---| "'vim-illuminate'"
    whichkey = { enabled = false },
  },
}

M.nvdash = { load_on_startup = false }
M.ui = {
  telescope = {
    enabled = false,
  },

  statusline = {
    theme = "minimal",
  },
  cmp = {

    icons = false,
    icons_left = false,
    style = "flat_dark",
    format_colors = {
      icon = "",
      lsp = false,
    },
    abbr_maxwidth = 80,
  },
}

return M
