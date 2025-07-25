return {
  ensure_installed = {
    "lua_ls", "gopls", "tailwindcss", "cssls", "ts_ls"
  },
  automatic_installation = true,
  handlers = {
    function(server_name)
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Enable snippets and folding
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Use delayed setup via on_attach wrapper
      lspconfig[server_name].setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.defer_fn(function()
            if not require("utils").should_attach_lsp(bufnr) then
              vim.lsp.buf_detach_client(bufnr, client.id)
              return
            end

            -- Disable expensive capabilities
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end, 1500) -- delay in milliseconds
        end,
        flags = {
          debounce_text_changes = 300,
          allow_incremental_sync = true,
        },
        settings = server_name == "lua_ls" and {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
              disable = { "trailing-space" }
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              }
            },
            telemetry = { enable = false }
          }
        } or nil
      }
    end,
  },
}
