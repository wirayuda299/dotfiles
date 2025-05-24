return {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    go = { "gofmt" },
    svelte = { "prettier" },
    astro = { "prettier" },
  },

  format_after_save = {
    timeout_ms = 3000,
    async = true,
    lsp_fallback = true,
  },
}
