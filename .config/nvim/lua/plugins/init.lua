return {
  {
    'stevearc/oil.nvim',
    cmd = { "Oil" },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = require("configs.oil"),
    keys = {
      { "<leader>e", "<cmd>Oil --float<cr>", silent = true }
    }
  },

  {

    dir = "~/Desktop/toggleterm",
    name = "toggleterm",
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup()
    end
  }
}
