return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    build = 'cargo build --release',

    opts = {
      keymap = {
        preset = 'enter',
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-y>'] = { 'select_and_accept' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false },
        list = {
          max_items = 50,
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      signature = { enabled = true },
      fuzzy = {
        implementation = 'prefer_rust',
      },
    },
    opts_extend = { 'sources.default' },
  },
}
