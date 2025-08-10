local M = {}

local map = vim.keymap.set

M.servers = {
  "lua_ls", "tsgo", "gopls", "cssls", "html", "rust_analyzer",
  "tailwindcss", "clangd", "lemminx", "astro", "svelte", "prismals",
  "graphql", "jsonls", "jdtls"
}

M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc, silent = true }
  end

  map("n", "K", "<cmd>LspUI hover<CR>", opts "Hover")
  map("n", "gr", "<cmd>LspUI reference<CR>", opts "References")
  map("n", "gd", "<cmd>LspUI definition<CR>", opts "Definition")
  map("n", "gt", "<cmd>LspUI type_definition<CR>", opts "Type definition")
  map("n", "gi", "<cmd>LspUI implementation<CR>", opts "Implementation")
  map("n", "<leader>rn", "<cmd>LspUI rename<CR>", opts "Rename")
  map("n", "<leader>ci", "<cmd>LspUI call_hierarchy incoming_calls<CR>", opts "Incoming Calls")
  map("n", "<leader>co", "<cmd>LspUI call_hierarchy outgoing_calls<CR>", opts "Outgoing Calls")
  map("n", "[d", function() vim.diagnostic.jump({ float = true, count = -1 }) end, opts "Prev Diagnostic")
  map("n", "]d", function() vim.diagnostic.jump({ float = true, count = 1 }) end, opts "Next Diagnostic")
end

M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- Start with basic capabilities, no Blink yet
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.setup = function()
  require("util").diagnostics()

  -- Load Blink capabilities only at InsertEnter
  vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
      local blink_caps = require("blink.cmp").get_lsp_capabilities()
      M.capabilities = vim.tbl_deep_extend("force", M.capabilities, blink_caps)

      -- Update all LSP configs with new capabilities
      vim.lsp.config("*", {
        on_init = M.on_init,
        capabilities = M.capabilities,
        flags = { debounce_text_changes = 150 },
      })
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(args)
    end,
  })

  vim.lsp.config("*", {
    on_init = M.on_init,
    capabilities = M.capabilities,
    flags = { debounce_text_changes = 150 },
  })

  vim.lsp.enable(M.servers)
end

return M
