return {

  {
    "pteroctopus/faster.nvim",
    lazy = true,
    config = function()
      require("faster").setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript" },
    lazy = true,
    event = { "VeryLazy" },
    opts = {},
  },

  {
    "Wansmer/symbol-usage.nvim",
    lazy = true,
    event = "LspAttach",
    opts = {
      vt_position = "end_of_line",
      text_format = function(symbol)
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          return string.format(" 󰌹 %s %s", num, usage)
        else
          return ""
        end
      end,
    },
  },
  {
    "azratul/expose-localhost.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "ExposeStart" },
    ft = { "html", "javascript", "typescript", "svelte", "astro" },
  },
  {
    "ray-x/go.nvim",
    lazy = true,
    ft = { "go", "gomod" },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("go").setup {}
    end,
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    lazy = true,
    config = function()
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      }
      require "configs.lspconfig"
    end,
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
    "ibhagwan/fzf-lua",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "find files" },
      { "<leader>,", "<cmd>FzfLua buffers<cr>", desc = "switch buffer" },
      { "<leader>fw", "<cmd>FzfLua live_grep<cr>", desc = "grep" },
      { "<leader>fr", "<cmd>FzfLuafLua oldfiles<cr>", desc = "recent" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "status" },
      { "<leader>km", "<cmd>FzfLua keymaps<cr>", desc = "keymaps" },
    },
    opts = require "configs.fzf",
  },
}
