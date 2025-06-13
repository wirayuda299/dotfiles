return {
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    opts = function(_, opts)
      local custom = require "configs.completion"
      return vim.tbl_deep_extend("force", opts, custom)
    end,
  },
  {
    "wirayuda299/peekdef",
    cmd = { "PeekOpen", "PeekClose" },
    config = function()
      require("peekdef").setup()
    end
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },
}
