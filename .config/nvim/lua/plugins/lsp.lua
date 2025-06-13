return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.diagnostic.config {
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
    }
    require "configs.lspconfig"
  end,
}
