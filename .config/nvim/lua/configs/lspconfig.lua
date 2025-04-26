local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

lspconfig.servers = {
  "lua_ls",
}

local default_servers = {
  "lua_ls",
  "clangd",
  "gopls",
  "ts_ls",
  "tailwindcss",
  "svelte",
  "astro",
  "cssls",
  "html",
  "jsonls",
  "cmake",
  "jdtls",
}

for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end
