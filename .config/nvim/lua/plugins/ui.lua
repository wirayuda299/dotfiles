return {
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
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    opts = {
      options = { theme = "nightfly" }
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      preset = "minimal"
    },
  }
}
