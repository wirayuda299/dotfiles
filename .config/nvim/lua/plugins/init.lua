return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  { "nvim-tree/nvim-web-devicons", enabled = false },

  {
    "folke/which-key.nvim",
    enabled = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },

  { "nvzone/volt", enabled = false },
  -- { "akinsho/bufferline.nvim", version = "*", dependencies = {} },
}
