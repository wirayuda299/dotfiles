dofile(vim.g.base46_cache .. "cmp")
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
    { name = "vim-dadbod-completion" },
    { name = "supermaven", group_index = 1, priority = 100 },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },

  sorting = {
    priority_weight = 1,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
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
