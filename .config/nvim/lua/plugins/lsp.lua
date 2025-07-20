return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    "mason-org/mason.nvim"
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local mason = require("mason")
    local mlsp = require("mason-lspconfig")
    local lspcfg = require("lspconfig")

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
        "lua_ls", "gopls", "tailwindcss", "cssls", "vtsls"
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

        ["lua_ls"] = function()
          lspcfg.lua_ls.setup {
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
}
