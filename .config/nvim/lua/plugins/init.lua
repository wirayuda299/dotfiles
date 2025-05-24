return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- BufReadPost is faster than BufReadPre
    config = function()
      local lsp_config = require("plugins.configs.lsp")
      lsp_config.defaults()
      -- Only enable servers for current buffer's filetype
      vim.schedule(function()
        vim.lsp.enable(lsp_config.servers)
      end)
    end,
  },

  -- Completion: Defer until actually entering insert mode
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = require("plugins.configs.completion").dependencies,
    config = function()
      -- Defer setup to reduce startup impact
      vim.schedule(function()
        require("plugins.configs.completion").setup()
      end)
    end,
  },

  -- Plenary: Only load when required by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Theme: Optimize loading and reduce features
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      -- Minimal setup for faster loading
      require("onedarkpro").setup({
        options = {
          transparency = true,
        },
        plugins = {
          nvim_tree = false,
          nvim_cmp = false,
          telescope = false,
          lsp = false,
        },
        styles = {
          -- Reduce processing overhead
          functions = "NONE",
          keywords = "NONE",
          variables = "NONE",
        },
      })
      vim.cmd.colorscheme("onedark_dark")
    end,
  },

  -- Statusline: Minimal config, load after UI is ready
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      set_vim_settings = false, -- Don't override vim settings
    }
  },

  -- Git signs: Only load for git repositories
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cond = function()
      -- Only load in git repos
      return vim.fn.isdirectory(".git") == 1 or vim.fn.finddir(".git", ".;") ~= ""
    end,
    opts = {
      -- Performance optimizations
      update_debounce = 200,
      max_file_length = 10000,
      preview_config = {
        border = "rounded",
        style = "minimal",
      },
    }
  },

  -- File tree: Only when explicitly needed
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
    opts = function()
      local config = require("plugins.configs.nvimtree")
      -- Add performance optimizations
      config.renderer = config.renderer or {}
      config.renderer.highlight_git = false -- Disable git highlighting for speed
      config.filesystem_watchers = {
        enable = false,                     -- Disable file watchers for large projects
      }
      return config
    end,
  },

  -- Treesitter: Optimize loading and reduce initial parsers
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = function()
      local config = require("plugins.configs.treesitter")
      -- Reduce initial parser installation
      config.ensure_installed = { "lua", "vim", "vimdoc" } -- Minimal set
      -- Add auto_install for lazy loading of other parsers
      config.auto_install = true
      config.sync_install = false
      return config
    end,
  },

  -- Expose localhost: Very specific use case, keep lazy
  {
    "azratul/expose-localhost.nvim",
    ft = { "html", "javascript", "typescript", "svelte", "astro" },
    cmd = { "ExposeStart" },
    cond = function()
      -- Only load in web development projects
      local web_files = { "package.json", "vite.config.js", "astro.config.mjs", "svelte.config.js" }
      for _, file in ipairs(web_files) do
        if vim.fn.filereadable(file) == 1 then
          return true
        end
      end
      return false
    end,
  },

  -- FZF: Optimize configuration and reduce key mappings
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      -- Essential mappings only
      { "<leader><space>", "<cmd>FzfLua files<cr>",       desc = "Find Files" },
      { "<leader>,",       "<cmd>FzfLua buffers<cr>",     desc = "Switch Buffer" },
      { "<leader>fw",      "<cmd>FzfLua live_grep<cr>",   desc = "Grep" },
      { "<leader>fr",      "<cmd>FzfLua oldfiles<cr>",    desc = "Recent" },
      { "<leader>gc",      "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader>gs",      "<cmd>FzfLua git_status<cr>",  desc = "Status" },
    },
    opts = function()
      local config = require("plugins.configs.fzf")
      -- Performance optimizations
      config.fzf_opts = {
        ["--layout"] = "reverse-list",
        ["--info"] = "inline-right",
        ["--height"] = "40%",
        ["--multi"] = true,
        ["--border"] = "none",
      }
      -- Disable preview for faster navigation
      config.files = { previewer = false }
      config.buffers = { previewer = false }
      return config
    end,
    config = function(_, opts)
      -- Simplified config without complex logic
      require("fzf-lua").setup(opts)
    end,
  },

  -- LazyGit: Clean up redundant settings
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    cond = function()
      return vim.fn.executable("lazygit") == 1
    end,
    init = function()
      -- Set globals at init to avoid config function overhead
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 1.0
      vim.g.lazygit_floating_window_border = "rounded"
      vim.g.lazygit_use_neovim_terminal = 1
    end,
  },

  -- Go: Only for Go projects
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gosum" },
    cond = function()
      return vim.fn.filereadable("go.mod") == 1 or vim.fn.executable("go") == 1
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- Minimal setup for faster loading
      disable_defaults = false,
      go = "go",         -- Use system go
      fillstruct = "gopls",
      dap_debug = false, -- Disable DAP integration unless needed
    },
    build = function()
      -- Async build to not block startup
      vim.schedule(function()
        require("go.install").update_all_sync()
      end)
    end,
  },

  -- Symbol usage: Optimize text formatting
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {
      vt_position = "end_of_line",
      request_pending_text = false, -- Disable pending text for performance
      text_format = function(symbol)
        if not symbol.references then return "" end
        local count = symbol.references
        if count == 0 then return " 󰌹 no usage" end
        return string.format(" 󰌹 %d", count) -- Simplified format
      end,
    },
  },

  -- Conform: Only on save for performance
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = function()
      local config = require("plugins.configs.conform")
      -- Add timeout for formatters
      config.format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      }
      return config
    end,
  },

  -- Indent guides: Lighter alternative with minimal config
  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      char = "│", -- Simple character
      exclude = {
        "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason"
      },
    },
  },
}
