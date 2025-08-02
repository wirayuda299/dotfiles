return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = require('plugins.configs.blink'),
  },
  {
    "wirayuda299/harppon",
    name = "harpoon",
    cmd = { "MarkAdd", "MarkFloat", "MarkJump", "MarkRemove" },
    keys = {
      { "<leader>ma", "<cmd>MarkAdd<cr>",    silent = true },
      { "<leader>mf", "<cmd>MarkFloat<cr>",  silent = true },
      { "<leader>mr", "<cmd>MarkRemove<cr>", silent = true },
      { "<leader>1",  "<cmd>MarkJump 1<cr>", silent = true },
      { "<leader>2",  "<cmd>MarkJump 2<cr>", silent = true },
      { "<leader>3",  "<cmd>MarkJump 3<cr>", silent = true },
      { "<leader>4",  "<cmd>MarkJump 4<cr>", silent = true },
      { "<leader>5",  "<cmd>MarkJump 5<cr>", silent = true },
    }
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
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
    cmd = "Hypersonic",
    opts = {},
  },
}
