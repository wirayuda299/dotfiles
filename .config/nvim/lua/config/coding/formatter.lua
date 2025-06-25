local opts = {
    formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        go = { "goimports", "gofumpt" },
        lua = { "stylua" },
    },
    format_on_save = {
        timeout_ms = 600,
        lsp_fallback = true,
    },
}
return opts
