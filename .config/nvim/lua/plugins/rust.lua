if not require('configs.pde').lsp.rust_analyzer then
   return {}
end

return {
   "mrcjkb/rustaceanvim",
   version = "^6",
   lazy = false,
   ft = { "rust" },
}
