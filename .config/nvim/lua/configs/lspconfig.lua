require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "gopls", "tailwindcss", "lua_ls", "ts_ls", "emmet_ls" }

vim.lsp.enable(servers)

lspconfig.ts_ls.setup {
  formatter = "prettier",
  setup = {
    single_file_support = true,
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end,
  },
}

lspconfig.tailwindcss.setup {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          "tw`([^`]*)",
          'tw="([^"]*)',
          'tw={"([^"}]*)',
          "tw\\.\\w+`([^`]*)",
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
}
