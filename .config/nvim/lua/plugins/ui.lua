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

}
