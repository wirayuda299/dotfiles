return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = require("configs.lazydev").lazydev,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = require("configs.lazydev").cmp,
  },
}

-- End of file.
