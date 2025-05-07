require("nvchad.configs.lspconfig").defaults()

local default_servers = {
   "lua_ls",
   "clangd",
   "gopls",
   "ts_ls",
   "tailwindcss",
   "svelte",
   "astro",
   "cssls",
   "cssmodules_ls",
   "dockerls",
   "html",
   "jsonls",
   "cmake",
   "jdtls",
   "rust_analyzer",
}

vim.lsp.enable(default_servers)
