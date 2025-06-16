return {

  {
    "ivanjermakov/troublesum.nvim",
    event = "LspAttach",
    config = function()
      require("troublesum").setup()
    end
  },
  {
    'danitrap/cheatsh.nvim',
    cmd = { "CheatSh" },
    opts = {}
  },
  {
    "aliqyan-21/wit.nvim",
    cmd = "WitSearch",
    config = function()
      require('wit').setup()
    end
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },

  }
}
