return {
  "ibhagwan/fzf-lua",
  lazy = true,
  cmd = "FzfLua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<cr>",       desc = "find files" },
    { "<leader>,",       "<cmd>FzfLua buffers<cr>",     desc = "switch buffer" },
    { "<leader>fw",      "<cmd>FzfLua live_grep<cr>",   desc = "grep" },
    { "<leader>gc",      "<cmd>FzfLua git_commits<cr>", desc = "commits" },
    { "<leader>gs",      "<cmd>FzfLua git_status<cr>",  desc = "status" },
  },
  opts = require "configs.fzf",
}
