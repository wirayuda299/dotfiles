if not require("configs.pde").lsp.gopls then
   return {}
end

return {
   "ray-x/go.nvim",
   ft = { "go", "gomod" }, -- cuma load pas buka file go/gomod
   dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
   },
   config = function()
      require("go").setup {}
   end,
   build = ':lua require("go.install").update_all_sync()',
}
