return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "VeryLazy",
    build = ":MasonUpdate",
    opts = {},
  },

  { "neovim/nvim-lspconfig", lazy = true, event = "VeryLazy" },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      { "williamboman/mason.nvim", lazy = true },
      { "neovim/nvim-lspconfig" },
    },
    opts = {
      ensure_installed = {
        "lua_ls", "gopls", "tailwindcss", "cssls", "vtsls", "rust_analyzer",
      },
      automatic_installation = true,
      handlers = require("plugins.configs.lsp"),
    }
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        window = {
          winblend = 0
        }
      }
    },
  }
}
