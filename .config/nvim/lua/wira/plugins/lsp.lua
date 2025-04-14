local ensure_tools = {
  'stylua',
  'shfmt',
  'gopls',
  'goimports',
  'gofumpt',
  'gomodifytags',
  'impl',
  'delve',
  'typescript-language-server',
  'tailwindcss-language-server',
  'svelte-language-server',
  'astro-language-server',
  'harper-ls',
}

local lsp_ui_config = {
  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = 'if_many',
      prefix = '●',
    },
    severity_sort = true,
    signs = true,
  },
  inlay_hints = {
    enabled = false,
    exclude = { 'vue' },
  },
  codelens = {
    enabled = false,
  },
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'saghen/blink.cmp',
    'williamboman/mason-lspconfig.nvim',
  },

  build = function()
    local mr = require 'mason-registry'
    mr.refresh(function()
      for _, tool in ipairs(ensure_tools) do
        local ok, p = pcall(mr.get_package, tool)
        if ok and not p:is_installed() then
          p:install()
        end
      end
    end)
  end,

  config = function()
    vim.diagnostic.config(lsp_ui_config.diagnostics)

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local on_attach = function(client, bufnr)
      if not lsp_ui_config.codelens.enabled then
        client.server_capabilities.codeLensProvider = false
      end

      local ft = vim.bo[bufnr].filetype
      if not lsp_ui_config.inlay_hints.enabled or vim.tbl_contains(lsp_ui_config.inlay_hints.exclude, ft) then
        client.server_capabilities.inlayHintProvider = false
      end
    end

    require('mason').setup()

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'ts_ls',
        'gopls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end,
        ['harper_ls'] = function()
          require('lspconfig').harper_ls.setup {
            settings = {
              ['harper-ls'] = {
                userDictPath = '',
                fileDictPath = '',
                filetypes = { 'markdown', 'text', 'gitcommit', 'javascript', 'typescript', 'typescriptreact', 'svelte', 'astro' },

                linters = {
                  SpellCheck = true,
                  SpelledNumbers = false,
                  AnA = true,
                  SentenceCapitalization = true,
                  UnclosedQuotes = true,
                  WrongQuotes = false,
                  LongSentences = true,
                  RepeatedWords = true,
                  Spaces = true,
                  Matcher = true,
                  CorrectNumberSuffix = true,
                },
                codeActions = {
                  ForceStable = false,
                },
                markdown = {
                  IgnoreLinkTitle = false,
                },
                diagnosticSeverity = 'hint',
                isolateEnglish = false,
                dialect = 'American',
              },
            },
          }
        end,

        ['ts_ls'] = function()
          require('lspconfig').ts_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            init_options = {
              hostInfo = 'neovim',
              preferences = {
                importModuleSpecifierPreference = 'relative',
                includePackageJsonAutoImports = 'auto',
                quotePreference = 'single',
                providePrefixAndSuffixTextForRename = true,
                allowIncompleteCompletions = true,
              },
            },
            filetypes = {
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
            },
            root_dir = function(fname)
              return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')(fname)
                or require('lspconfig.util').find_git_ancestor(fname)
            end,
          }
        end,

        ['tailwindcss'] = function()
          require('lspconfig').tailwindcss.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              'html',
              'css',
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
              'svelte',
              'astro',
            },
          }
        end,

        ['gopls'] = function()
          require('lspconfig').gopls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { 'gopls', 'serve' },
            filetypes = { 'go', 'gomod' },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
            },
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
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                usePlaceholders = false,
                completeUnimported = true,
                directoryFilters = { '-.git', '-.vscode', '-.idea', '-node_modules' },
                semanticTokens = true,
                staticcheck = true,
              },
            },
          }
        end,

        ['lua_ls'] = function()
          require('lspconfig').lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2',
                  },
                },
              },
            },
          }
        end,
      },
    }
  end,
}
