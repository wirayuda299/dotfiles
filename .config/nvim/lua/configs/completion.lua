local cmp = require "cmp"
local cmpSelect = cmp.SelectBehavior.Select
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)
return {
  mapping = {
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmpSelect },
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmpSelect },
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp", priority = 1000, max_item_count = 10 },
    { name = "luasnip", priority = 750, keyword_length = 7 },
    { name = "path", priority = 250, keyword_length = 3 },
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      -- Removed: kind, length, order (slower comparators)
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
    fields = { "kind", "abbr" }, -- Remove menu field
    format = function(entry, vim_item)
      -- Ultra-minimal formatting
      vim_item.menu = nil -- Remove source name

      -- Truncate long completions
      if #vim_item.abbr > 30 then
        vim_item.abbr = vim_item.abbr:sub(1, 27) .. "..."
      end

      return vim_item
    end,
  },
}
