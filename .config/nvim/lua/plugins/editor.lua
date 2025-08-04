return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup()
    end
  },
  {
    "y3owk1n/warp.nvim",
    cmd = {
      "WarpAddFile",
      "WarpAddOnScreenFiles",
      "WarpDelFile",
      "WarpMoveTo",
      "WarpShowList",
      "WarpClearCurrentList",
      "WarpClearAllList",
      "WarpGoToIndex",
    },
    opts = {},
    keys = {

      {
        "<C-a>",
        "<cmd>WarpAddFile<cr>",
        desc = "[Warp] Add",
      },
      {
        "<leader>hd",
        "<cmd>WarpDelFile<cr>",
        desc = "[Warp] Delete",
      },
      {
        "<C-l>",
        "<cmd>WarpShowList<cr>",
        desc = "[Warp] Show list",
      },

      {
        "<leader>1",
        "<cmd>WarpGoToIndex 1<cr>",
        desc = "[Warp] Goto #1",
      },
      {
        "<leader>2",
        "<cmd>WarpGoToIndex 2<cr>",
        desc = "[Warp] Goto #2",
      },
      {
        "<leader>3",
        "<cmd>WarpGoToIndex 3<cr>",
        desc = "[Warp] Goto #3",
      },
      {
        "<leader>4",
        "<cmd>WarpGoToIndex 4<cr>",
        desc = "[Warp] Goto #4",
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = require('plugins.configs.blink'),
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit", silent = true }
    }
  },
  {
    "CRAG666/code_runner.nvim",
    cmd = "RunCode",
    cond = function()
      return not require("utils").should_disable_for_java()
    end
  },
  {
    'stevearc/oil.nvim',
    cmd = { "Oil" },
    opts = require('plugins.configs.oil'),
    keys = {
      { "<leader>e", "<cmd>Oil --float<cr>", silent = true }
    }
  },

  {
    "tomiis4/Hypersonic.nvim",
    event = "CmdlineEnter",
    desc = "Explain regex in commandline",
    cond = function()
      return not require("utils").should_disable_for_java()
    end,
    cmd = "Hypersonic",
    opts = {},
  },
}
