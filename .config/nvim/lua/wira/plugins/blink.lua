return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'saghen/blink.compat',
    },
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
        use_nvim_cmp_as_default = false,
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = {
          max_items = 50,
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
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
