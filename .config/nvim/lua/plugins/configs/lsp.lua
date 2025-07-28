return {
  function(server_name)
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

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

        client.server_capabilities.semanticTokensProvider = nil
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
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
}
