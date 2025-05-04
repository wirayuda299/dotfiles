---@type NvPluginSpec[]
local plugins = {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      local custom = {
        mapping = {
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- enter buat confirm pilihan
          ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "async_path", priority = 250 }, -- For luasnip users.
        },
      }
      return vim.tbl_deep_extend("force", opts, custom)
    end,
  },
}
return plugins
