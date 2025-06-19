return {
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `LspAttach`
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = "classic",
        transparent_bg = true, -- Set the background of the diagnostic to transparent
        options = {
          add_messages = false,
          throttle = 10,
          overflow = {
            mode = "oneline"
          }
        }
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
    ft = { "html", "javascriptreact", "typescriptreact" },
    event = "VeryLazy",
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    opts = function(_, opts)
      local custom = require "configs.completion"
      return vim.tbl_deep_extend("force", opts, custom)
    end,
  },
}
