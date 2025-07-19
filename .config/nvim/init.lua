vim.loader.enable()

vim.g.mapleader = " "
vim.g.localleader = " "


require("autocmds")
vim.schedule(function()
  require("indent")
  require("options")
  require("keymaps")
  require("explorer").setup()
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--single-branch",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      local data_path = vim.fn.stdpath("data")
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_execute_on_save = false
    end

  },

  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    enabled = false,
    config = function()
      require("lsp-lens").setup({})
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "javascript", "typescript", "typescriptreact", "svelte", "astro" },
    config = function()
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
        require("ts-error-translator").translate_diagnostics(err, result, ctx)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
      end
    end
  },
  {
    'nacro90/numb.nvim',
    event = "CmdlineEnter",
    config = function()
      require('numb').setup()
    end,
  },

  {
    'saghen/blink.cmp',
    event = "InsertEnter",
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    build = "cargo build --release",

    opts = {
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      completion = {
        list = { max_items = 8 }, -- Reduced from 10
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300, -- Increased from 200
        },
        accept = { auto_brackets = { enabled = true } },
      },
      signature = { enabled = true },
      sources = {
        default = { 'lsp', "path", "snippets" },
        providers = {
          lsp = { max_items = 8 },     -- Reduced from 10
          path = { max_items = 8 },    -- Reduced from 10
          snippets = { max_items = 8 } -- Reduced from 10
        }
      },
      fuzzy = { implementation = "prefer_rust" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Changed from BufReadPre to BufReadPost
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "j-hui/fidget.nvim",
      "yioneko/nvim-vtsls",
      {
        "mason-org/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts_extend = { "ensure_installed" },
        opts = {
          ensure_installed = {
            "goimports", "gofumpt",
            "gomodifytags", "impl", "delve",
          },
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              packageuninstalled = "✗"
            }
          },
        },
      }
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local mason = require("mason")
      local mlsp = require("mason-lspconfig")
      local lspcfg = require("lspconfig")

      -- Async file size check
      local function should_attach_lsp(bufnr)
        local max_filesize = 100 * 1024 -- 100KB
        local name = vim.api.nvim_buf_get_name(bufnr)

        if name == "" or name:match("^%w+://") then
          return false
        end

        -- Quick sync check for immediate decision
        local ok, stats = pcall(vim.uv.fs_stat, name)
        if ok and stats and stats.size > max_filesize then
          return false
        end

        return true
      end

      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
          },
        },
      })

      mason.setup()

      mlsp.setup({
        ensure_installed = {
          "lua_ls", "gopls", "tailwindcss", "cssls", "omnisharp", "vtsls"
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspcfg[server_name].setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200, -- Increased debounce
              },
            }
          end,

          ["vtsls"] = function()
            lspcfg.vtsls.setup {
              capabilities = capabilities,
              root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200,
              },
              -- Simplified settings for faster startup
              settings = {
                vtsls = {
                  autoUseWorkspaceTsdk = true,
                  experimental = {
                    completion = {
                      enableServerSideFuzzyMatch = true,
                      entriesLimit = 20, -- Reduced from 50
                    },
                  },
                },
                typescript = {
                  updateImportsOnFileMove = { enabled = "always" },
                  suggest = {
                    completeFunctionCalls = true,
                    autoImports = true,
                    includeCompletionsForModuleExports = true,
                  },
                  tsserver = {
                    maxTsServerMemory = 4096, -- Reduced from 8192
                  },
                  preferences = {
                    importModuleSpecifier = "project-relative",
                    quotePreference = "auto",
                  },
                  -- Simplified inlay hints
                  inlayHints = {
                    variableTypes = { enabled = false },           -- Disabled for performance
                    parameterTypes = { enabled = false },          -- Disabled for performance
                    functionLikeReturnTypes = { enabled = false }, -- Disabled for performance
                    parameterNames = { enabled = "none" },         -- Disabled for performance
                  },
                },
                javascript = {
                  updateImportsOnFileMove = { enabled = "always" },
                  suggest = {
                    completeFunctionCalls = true,
                    autoImports = true,
                  },
                },
              },
            }
          end,

          ["tailwindcss"] = function()
            lspcfg.tailwindcss.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200,
              },
              settings = {
                tailwindCSS = {
                  filetypes_exclude = { "markdown" },
                  experimental = {
                    classRegex = {
                      "tw([^])",
                      "tw=\"([^\"])",
                      "tw={\"([^\"}])",
                    },
                  },
                },
              }
            }
          end,

          ["gopls"] = function()
            lspcfg.gopls.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200,
              },
              settings = {
                gopls = {
                  memoryMode = "DegradeClosed",
                  expandWorkspaceToModule = false,
                  analyses = {
                    unusedparams = false,
                    nilness = false,
                    unusedwrite = false,
                    useany = false,
                  },
                  staticcheck = false,
                  vulncheck = "Off",
                  gofumpt = true,
                  usePlaceholders = true,
                  completeUnimported = true,
                  directoryFilters = {
                    "-.git", "-.vscode", "-.idea", "-.vscode-test",
                    "-node_modules", "-vendor", "-build", "-dist"
                  },
                  semanticTokens = false,
                  codelenses = {
                    gc_details = false,
                    generate = false, -- Disabled for performance
                    test = false,     -- Disabled for performance
                    tidy = false,     -- Disabled for performance
                  },
                  hints = {
                    assignVariableTypes = false,
                    compositeLiteralFields = false,
                    compositeLiteralTypes = false,
                    constantValues = false,
                    functionTypeParameters = false,
                    parameterNames = false,
                    rangeVariableTypes = false,
                  },
                }
              }
            }
          end,

          ["cssls"] = function()
            lspcfg.cssls.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200,
              },
              settings = {
                css = {
                  validate = true,
                  lint = {
                    unknownAtRules = "ignore"
                  }
                },
              }
            }
          end,

          ["lua_ls"] = function()
            lspcfg.lua_ls.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                if not should_attach_lsp(bufnr) then
                  vim.lsp.buf_detach_client(bufnr, client.id)
                  return
                end
                client.server_capabilities.semanticTokensProvider = nil
              end,
              flags = {
                debounce_text_changes = 200,
              },
              settings = {
                Lua = {
                  format = {
                    enable = true,
                    defaultConfig = {
                      indent_style = "space",
                      indent_size = "2",
                    }
                  },
                  workspace = {
                    checkThirdParty = false,
                    maxPreload = 500,      -- Reduced from 1000
                    preloadFileSize = 500, -- Reduced from 1000
                  },
                  diagnostics = {
                    workspaceDelay = 2000, -- Increased from 1000
                  },
                  semantic = {
                    enable = false,
                  },
                }
              }
            }
          end,
        },
      })

      vim.diagnostic.config({
        signs = false,
        virtual_text = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "log", "txt", "markdown" },
        callback = function(args)
          vim.defer_fn(function()
            local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf))
            if file_size > 1024 * 1024 then -- 1MB
              vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = args.buf }))
            end
          end, 100)
        end
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader><space>", "<cmd>FzfLua files<cr>" },
      { "<leader>,",       "<cmd>FzfLua buffers<cr>" },
      { "<leader>fw",      "<cmd>FzfLua live_grep<cr>" },
    },
    opts = function()
      return {
        fzf_opts = {
          ["--layout"] = "reverse",
          ["--info"] = "inline-right",
          ["--height"] = "100%",
          ["--multi"] = true,
          ["--ansi"] = true,
          ["--prompt"] = "❯ ",
          ["--pointer"] = "▶",
          ["--marker"] = "✓",
        },
        previewers = {
          builtin = {
            syntax = false,
            syntax_limit_b = 1024 * 50,
            limit_b = 1024 * 1024 * 1,
          },
          bat = {
            cmd = "bat",
            args = "--color=always --style=numbers --line-range=:100",
          },
        },
        winopts = {
          height = 0.85,
          width = 0.85,
          row = 0.5,
          col = 0.5,
          border = "rounded",
          backdrop = 60,
          preview = {
            default = "bat",
            delay = 50,
            layout = "flex",
            flip_columns = 120,
            horizontal = "right:30%",
            vertical = "down:40%",
          },
        },
        files = {
          cmd =
          "rg --files --hidden --glob '!.git' --glob '!node_modules' --glob '!tmp' --glob '!dist' --glob '!build' --glob '!.next' --glob '!coverage' --glob '!out'",
          cwd_prompt = false,
        },
        grep = {
          rg_opts =
          "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git' --glob '!node_modules' --glob '!dist' --glob '!build'",
          input_prompt = "Grep❯ ",
          multiprocess = true,
          git_icons = false,
          file_icons = false,
          color_icons = false,
        },
      }
    end,
  },
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "default" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    cache = { enabled = true },
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin",
        "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "syntax", "nvim-treesitter",
        "2html_plugin", "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw",
        "netrwplugin", "spellfile_plugin", "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin"
      }
    },
  },
})
