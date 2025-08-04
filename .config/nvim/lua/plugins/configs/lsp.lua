local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()


return {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
    }
  end,
}
