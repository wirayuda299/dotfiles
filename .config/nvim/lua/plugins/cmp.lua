-- ~/.config/nvim/lua/custom/plugins.lua
---@type NvPluginSpec[]
local plugins = {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      -- merge default opts dengan custom mapping
      local custom = {
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Tab>"] = cmp.mapping.confirm { select = true },
        },
      }
      return vim.tbl_deep_extend("force", opts, custom)
    end,
  },
}
return plugins
