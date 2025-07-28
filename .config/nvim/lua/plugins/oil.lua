return {
  'stevearc/oil.nvim',
  cmd = { "Oil" },
  opts = require('plugins.configs.oil'),
  keys = {
    { "<leader>e", "<cmd>Oil --float<cr>", silent = true }
  }
}
