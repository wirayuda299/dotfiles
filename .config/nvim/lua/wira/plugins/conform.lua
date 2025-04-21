return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    format_on_save = {
      lsp_fallback = true,
      async = true,
      timeout_ms = 3000,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      go = { 'gofmt' },
      svelte = { 'prettier' },
      astro = { 'prettier' },
      cmake = { 'cmakelint' },
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)
  end,
}
