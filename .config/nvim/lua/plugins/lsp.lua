return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "VeryLazy",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "goimports", "gofumpt"
      }
    },
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = 'java',
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "jdtls"
          }
        },
        ensure_installed = {
          "lua_ls", "gopls", "tailwindcss", "cssls", "vtsls", "rust_analyzer", "jdtls"
        },
        automatic_installation = true,
        handlers = function()
          return require("plugins.configs.lsp")
        end
      })
    end
  },


}
