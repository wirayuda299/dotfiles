return {
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
            { name = "nvim_lsp",        priority = 1000 },
            { name = "luasnip",         priority = 750 },
            { name = "async_path",      priority = 250 }, -- For luasnip users.
            { name = "render-markdown", priority = 200 },
            { name = "lazydev",         group_index = 0, }
         },
         completion = {
            completeopt = "menu,menuone,noselect",
         },

         performance = {
            debounce = 0,
            throttle = 0,
            fetching_timeout = 20,
            confirm_resolve_timeout = 20,
            async_budget = 1,
            max_view_entries = 50,
         },
         preselect = cmp.PreselectMode.None,
      }
      return vim.tbl_deep_extend("force", opts, custom)
   end,
}
