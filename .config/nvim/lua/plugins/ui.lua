return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { theme = "nightfly" }
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "VeryLazy",
    config = function()
      require("catppuccin").setup({
        transparent_background = true
      })
      vim.cmd("colorscheme catppuccin-mocha")
    end
  },
}
