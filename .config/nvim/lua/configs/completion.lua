local cmp = require "cmp"
local cmpSelect = cmp.SelectBehavior.Select
local compare = require "cmp.config.compare"

local source_names = {
  nvim_lsp = "(LSP)",
  luasnip = "(Snippet)",
  path = "(Path)",
}

local duplicates = {
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}

return {
  mapping = {
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmpSelect },
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmpSelect },
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp",             priority = 1000,    max_item_count = 10 },
    { name = "luasnip",              priority = 100,     keyword_length = 2 },
    { name = "path",                 keyword_length = 3, priority = 700 },
    { name = "vim-dadbod-completion" },

    -- { name = "supermaven",           group_index = 1,   priority = 100 },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  formatting = {
    format = function(entry, item)
      local duplicates_default = 0

      item.menu = source_names[entry.source.name]
      item.dup = duplicates[entry.source.name] or duplicates_default

      return item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.score,
      compare.recently_used,
      compare.offset,
      compare.exact,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
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
    debounce = 50,
    throttle = 20,
    fetching_timeout = 50,
    confirm_resolve_timeout = 20,
    async_budget = 2,
    max_view_entries = 35,
  },
  preselect = cmp.PreselectMode.None,

}
