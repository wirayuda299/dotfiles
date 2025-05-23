return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"
    local cmpSelect = cmp.SelectBehavior.Select
    local defaults = require "cmp.config.default"()

    local custom = {
      mapping = {
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Down>"] = cmp.mapping.select_next_item { behavior = cmpSelect },
        ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmpSelect },
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000, max_item_count = 10 },
        { name = "luasnip", priority = 750, keyword_length = 7 },
        { name = "path", priority = 250, keyword_length = 3 },
        { name = "lazydev", group_index = 0 },
        { name = "sql", priority = 200 },
      },
      auto_brackets = {},
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      sorting = defaults.sorting,
      performance = {
        debounce = 150,
        throttle = 80,
        fetching_timeout = 50,
        confirm_resolve_timeout = 20,
        async_budget = 2,
        max_view_entries = 35,
      },

      preselect = cmp.PreselectMode.None,
    }
    return vim.tbl_deep_extend("force", opts, custom)
  end,
}
