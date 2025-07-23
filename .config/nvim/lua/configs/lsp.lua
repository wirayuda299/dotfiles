return {
  ensure_installed = {
    "lua_ls", "gopls", "tailwindcss", "cssls", "ts_ls"
  },
  automatic_installation = true,
  handlers = {
    function(server_name)
      local lspconfig = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      lspconfig[server_name].setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if not require("utils").should_attach_lsp(bufnr) then
            vim.lsp.buf_detach_client(bufnr, client.id)
            return
          end

          -- Disable resource-heavy features
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.documentFormattingProvider = nil
          client.server_capabilities.documentRangeFormattingProvider = nil
        end,
        flags = {
          debounce_text_changes = 300,         -- Increased debounce for better performance
          allow_incremental_sync = true,
        },
        settings = {
          Lua = server_name == "lua_ls" and {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
              disable = { "trailing-space" }
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library"
              }
            },
            telemetry = { enable = false }
          } or nil,
        }
      }
    end,
  },
}
