return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<cr>" },
    { "<leader>fb",      "<cmd>FzfLua buffers<cr>" },
    { "<leader>gr",      "<cmd>FzfLua live_grep<cr>" },
  },
  opts = require('plugins.configs.fzf')
}
