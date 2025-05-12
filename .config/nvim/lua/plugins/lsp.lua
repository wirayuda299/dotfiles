return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require "configs.lspconfig"
    vim.diagnostic.config {
      virtual_text = true,
      signs = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    }
  end,
}
