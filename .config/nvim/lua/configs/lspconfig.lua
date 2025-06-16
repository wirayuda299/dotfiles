require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "gopls",
  "tailwindcss",
  "lua_ls",
  "ts_ls",
  -- "emmet_ls",
}


lspconfig.ts_ls.setup {
  root_dir = require('lspconfig.util').root_pattern('tsconfig.json', '.git', "package.json"),

  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
    end,
  },
}


vim.lsp.enable(servers)
