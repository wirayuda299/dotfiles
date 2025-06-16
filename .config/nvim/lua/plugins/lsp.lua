return {
  {
    'VidocqH/lsp-lens.nvim',
    event = "LspAttach",
    config = function()
      require 'lsp-lens'.setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config {
        virtual_text = false,
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
}
