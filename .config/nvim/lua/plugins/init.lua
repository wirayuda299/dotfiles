local toggle = require "configs.enabled_modules"

return {
  {
    { "nvim-treesitter/nvim-treesitter", enabled = toggle.treesitter },
    { "lewis6991/gitsigns.nvim", enabled = toggle.gitsigns },
    { "lukas-reineke/indent-blankline.nvim", enabled = toggle.indent_blankline },
    { "folke/which-key.nvim", enabled = toggle.which_key },
    { "nvim-telescope/telescope.nvim", enabled = toggle.telescope },
    { "nvzone/volt", enabled = toggle.volt },
    { "nvzone/minty", enabled = toggle.minty },
    { "ray-x/cmp-treesitter", enabled = toggle.cmp_treesitter },
    { "akinsho/bufferline.nvim", enabled = toggle.bufferline },
    {
      "azratul/expose-localhost.nvim",
      lazy = true,
      enabled = toggle.exposed,
      event = "VeryLazy",
      cmd = { "ExposeStart" },
      ft = { "html", "javascript", "typescript", "svelte", "astro" },
    },

    {
      "Wansmer/symbol-usage.nvim",
      lazy = true,
      enabled = toggle.symbol_usage,
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
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    lazy = true,
    event = { "VeryLazy" },
    opts = {},
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
    event = { "VeryLazy" },
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
