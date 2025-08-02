return {
  function(server_name)
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
      end,
    }
  end,
}
