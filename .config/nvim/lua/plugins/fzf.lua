return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<cr>" },
    { "<leader>,",       "<cmd>FzfLua buffers<cr>" },
    { "<leader>gr",      "<cmd>FzfLua live_grep<cr>" },
  },
  opts = function()
    return require("configs.fzf")
  end,
}
