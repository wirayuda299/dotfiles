local opts = {
  snippets = { preset = "luasnip" },
  cmdline = { enabled = true },
  appearance = { nerd_font_variant = "normal" },
  fuzzy = { implementation = "prefer_rust" },
  sources = {
    default = { "lsp", "snippets", "path" },
    lsp = { max_items = 8 },     -- Reduced from 10
    path = { max_items = 8 },    -- Reduced from 10
    snippets = { max_items = 8 } -- Reduced from 10

  },

  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<Down>"] = { "select_next", "snippet_forward", "fallback" },
    ["<Up>"] = { "select_prev", "snippet_backward", "fallback" },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  },

  completion = {
    -- ghost_text = { enabled = true },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "single" },
    },
    list = { max_items = 8 },
    menu = {
      scrollbar = false,
      border = "single",

    }
  },
}

return opts
