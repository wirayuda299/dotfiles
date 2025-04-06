return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'williamboman/mason.nvim',
      'saghen/blink.cmp',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = function()
      local ret = { -- ✅ Define `ret`
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
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        servers = {
          ts_ls = {
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
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
            root_dir = function(fname)
              return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')(fname)
                or require('lspconfig.util').vim.fs.dirname(fname)
            end,
            on_attach = function(client, bufnr)
              client.server_capabilities.document_formatting = false
              client.server_capabilities.document_range_formatting = false
            end,
          },
          tailwindcss = {
            filetypes_exclude = { 'markdown' },
            filetypes_include = {},
          },
          gopls = {
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
                usePlaceholders = true,
                completeUnimported = true,
                directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
                semanticTokens = true,
                staticcheck = true,
              },
            },
            on_attach = function(client, bufnr)
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end,
          },
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = 'Replace',
                },
                doc = {
                  privateName = { '^_' },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = 'Disable',
                  semicolon = 'Disable',
                  arrayIndex = 'Disable',
                },
              },
            },
          },
        },
      }
      return ret
    end,

    config = function(_, opts)
      require('mason').setup {

        opts = {
          ensure_installed = {
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
          },
        },
        config = function(_, opts)
          require('mason').setup(opts)
          local mr = require 'mason-registry'
          mr.refresh(function()
            for _, tool in ipairs(opts.ensure_installed) do
              local p = mr.get_package(tool)
              if not p:is_installed() then
                p:install()
              end
            end
          end)
        end,
      }
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'gopls', 'tailwindcss', 'ts_ls' },
      }

      vim.diagnostic.config(opts.diagnostics)

      -- Set up LSP servers
      local lspconfig = require 'lspconfig'
      for server, config in pairs(opts.servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
}
