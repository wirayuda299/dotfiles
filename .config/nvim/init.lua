vim.loader.enable()

vim.g.mapleader = " "
vim.cmd("colorscheme default")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--single-branch",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "ibhagwan/fzf-lua",
      keys = {
        { "<leader><space>", "<cmd>FzfLua files<cr>" },
        { "<leader>,",       "<cmd>FzfLua buffers<cr>" },
        { "<leader>gr",      "<cmd>FzfLua live_grep<cr>" },
      },
      opts = function()
        return require("configs.fzf")
      end,
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      event = { "InsertEnter" },
      dependencies = { "rafamadriz/friendly-snippets" },
      opts = function()
        return require "configs.blink"
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        root_dir = { ".luarc.json", ".git" },
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          "${3rd}/love2d/library",
        },
      },
    },
    {
      "j-hui/fidget.nvim",
      event = "LspAttach",
      opts = {
        notification = {
          window = {
            winblend = 0
          }
        }
      }
    },
    {
      "williamboman/mason-lspconfig.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        {
          "williamboman/mason.nvim",
          cmd = "Mason",
          build = ":MasonUpdate",
          opts = {}
        },
        { "neovim/nvim-lspconfig", lazy = true }
      },
      opts = require("configs.lsp"),
    },

    {
      dir = "~/Desktop/numb",
      name = "numb",
      event = "CmdLineEnter",
    },
    {
      dir = "~/Desktop/harpoon",
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
      "dmmulroy/ts-error-translator.nvim",
      ft = { "javascript", "typescript", "typescriptreact", "svelte", "astro" },
      init = function()
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
          require("ts-error-translator").translate_diagnostics(err, result, ctx)
          vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
        end
      end
    },

    {
      'stevearc/oil.nvim',
      cmd = { "Oil" },
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = require("configs.oil"),
      keys = {
        { "<leader>e", "<cmd>Oil --float<cr>", silent = true }
      }
    },


    {
      'akinsho/toggleterm.nvim',
      version = "*",
      cmd = "ToggleTerm",
      keys = {
        { "<C-t>", "<cmd>ToggleTerm<cr>", silent = true }
      }

    },
    {
      "supermaven-inc/supermaven-nvim",
      event = "InsertEnter",
      cmd = { "SupermavenUseFree", "SupermavenStatus" },
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },
    {

      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod',                     lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      },
      cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
      },
      keys = {
        { "n", "<C-d>", "<cmd>DBUIToggle<cr>", { silent = true } }
      },
      init = function()
        local data_path = vim.fn.stdpath("data")
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_auto_execute_table_helpers = 1
        vim.g.db_ui_show_database_icon = true
        vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
        vim.g.db_ui_use_nerd_fonts = true
        vim.g.db_ui_use_nvim_notify = true
        vim.g.db_ui_execute_on_save = false
      end
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
    }
  },
  defaults = { lazy = true, version = false, },
  install = { colorscheme = { "default" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    cache = { enabled = true },
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin", "editorconfig",
        "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "syntax", "nvim-treesitter",
        "2html_plugin", "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw",
        "netrwplugin", "spellfile_plugin", "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin", "osc52", "shada",
        "spellfile", "man"
      }
    },
  },


})

require("options")
require("autocmds")

vim.schedule(function()
  require("keymaps")
end)

vim.diagnostic.config({
  signs = false,
  virtual_text = {
    spacing = 2,
    source = false,
  },
  float = {
    focusable = false,
    style = "minimal",
    border = "none",
    source = "if_many",
    header = "",
    prefix = "",
    max_width = 80,
  },
  update_in_insert = false,
  severity_sort = true,
})
