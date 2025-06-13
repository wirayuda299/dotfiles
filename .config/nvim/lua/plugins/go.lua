return {
  "ray-x/go.nvim",
  lazy = true,
  ft = { "go", "gomod" },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("go").setup {}
  end,
  build = ':lua require("go.install").update_all_sync()',
}
