return {
  {
    "vuki656/package-info.nvim",
    dependencies = {{"MunifTanjim/nui.nvim", lazy = true}}, -- Fixed spacing
    ft = "json",
    config = function()
      require("package-info").setup()
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
      { "<C-t>", "<cmd>ToggleTerm<cr>", silent = true },
    },
    opts = {
      size = 10
    }
  },

  {
    'stevearc/oil.nvim',
    cmd =  "Oil",
    opts = function()
      return require('plugins.configs.oil')
    end,
    keys = {
      { "<leader>e", "<cmd>Oil --float<cr>", silent = true }
    }
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader><space>", "<cmd>FzfLua files<cr>" },
      { "<leader>fb",      "<cmd>FzfLua buffers<cr>" },
      { "<leader>gr",      "<cmd>FzfLua live_grep<cr>" },
    },
    opts = function()
      return require('plugins.configs.fzf')
    end
  },

  {
    'saghen/blink.cmp',
    event =  "InsertEnter",
    dependencies = { { 'rafamadriz/friendly-snippets', lazy = true } },
    version = '1.*',
    opts = function()
      return require("plugins.configs.blink")
    end,
  }
}
