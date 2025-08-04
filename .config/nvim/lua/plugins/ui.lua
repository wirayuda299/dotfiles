return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
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
    event = { "BufReadPre", "BufNewFile" },
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
