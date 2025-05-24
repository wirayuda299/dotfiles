local M = {}

M.dependencies = {
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "FelipeLema/cmp-async-path",
}

M.setup = function()
  local cmp = require "cmp"
  local cmp_select = cmp.SelectBehavior.Select

  cmp.setup {
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    -- keymap
    mapping = {
      ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp_select },
      ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp_select },
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = {
      { name = "nvim_lsp",   priority = 1000, max_item_count = 10 },
      { name = "luasnip",    priority = 750,  keyword_length = 7 },
      { name = "async_path", priority = 250,  keyword_length = 3 },
    },
    performance = {
      debounce = 300,
      throttle = 80,
      fetching_timeout = 50,
      confirm_resolve_timeout = 20,
      async_budget = 2,
      max_view_entries = 35,
    },
    preselect = cmp.PreselectMode.None,
  }
end

return M
