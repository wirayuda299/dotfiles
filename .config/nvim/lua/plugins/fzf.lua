return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<cr>" },
    { "<leader>,",       "<cmd>FzfLua buffers<cr>" },
    { "<leader>fw",      "<cmd>FzfLua live_grep<cr>" },
  },
  opts = function()
    return require("configs.fzf")
  end,
}
