local cmp = require "cmp"
local cmpSelect = cmp.SelectBehavior.Select

return {
  mapping = {
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmpSelect },
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmpSelect },
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp", priority = 1000, max_item_count = 10 },
    { name = "luasnip", keyword_length = 2 },
    { name = "path", keyword_length = 3 },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },

  sorting = {
    priority_weight = 1,
    comparators = {
      cmp.config.compare.offset, -- prioritizes items closer to the cursor
      cmp.config.compare.exact, -- prioritizes items starting with exactly the same prefix
      cmp.config.compare.score, -- prioritizes item similarity score
      cmp.config.compare.recently_used, -- prioritizes recently used items
      cmp.config.compare.kind, -- prioritizes items with the same kind
      cmp.config.compare.sort_text, -- prioritizes prefix matches within completion items
      cmp.config.compare.length, -- prioritizes shorter completion items
      cmp.config.compare.order, -- prioritizes items in the same received order
      -- Removed: kind, length, order (slower comparators)
    },
    debug = {
      priority = true,
    },
  },
  window = {
    completion = {
      border = "none",
      winhighlight = "", -- No custom highlighting
      scrollbar = false,
    },
    documentation = {
      border = "none",
      winhighlight = "",
      max_width = 60,
      max_height = 15,
    },
  },
  performance = {
    debounce = 150,
    throttle = 80,
    fetching_timeout = 50,
    confirm_resolve_timeout = 20,
    async_budget = 2,
    max_view_entries = 35,
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    fields = { "kind", "abbr" },
    format = function(_, vim_item)
      vim_item.menu = nil

      if #vim_item.abbr > 30 then
        vim_item.abbr = vim_item.abbr:sub(1, 27) .. "..."
      end

      return vim_item
    end,
  },
}
