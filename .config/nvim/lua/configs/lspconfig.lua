require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "gopls", "tailwindcss", "lua_ls", "ts_ls" }
vim.lsp.enable(servers)

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
lspconfig.gopls.setup {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = false,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}
lspconfig.ts_ls.setup {
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end,
  },
}
-- Custom Tailwind CSS settings
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
