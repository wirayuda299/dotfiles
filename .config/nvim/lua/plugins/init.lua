return {
   {
      "stevearc/conform.nvim",
      event = "BufWritePre",
      opts = require "configs.conform",
   },
   {
      "neovim/nvim-lspconfig",
      config = function()
         require "configs.lspconfig"
         vim.diagnostic.config {
            virtual_text = true,
            signs = false,
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

         vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
      end,
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
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      keys = {
         { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      },
      config = function()
         vim.g.lazygit_floating_window_winblend = 0         -- No transparency
         vim.g.lazygit_floating_window_scaling_factor = 1.0 -- Full scale window
         vim.g.lazygit_floating_window_border = "rounded"   -- Rounded border for better look
         vim.g.lazygit_use_neovim_terminal = 1
      end,
   },
   {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = require("configs.lazydev").lazydev,
   },
   {
      "hrsh7th/nvim-cmp",
      opts = require("configs.lazydev").cmp,
   },
   {
      "ray-x/go.nvim",
      ft = { "go", "gomod" }, -- cuma load pas buka file go/gomod
      dependencies = {
         "neovim/nvim-lspconfig",
         "nvim-treesitter/nvim-treesitter",
      },
      config = function()
         require("go").setup {}
      end,
      build = ':lua require("go.install").update_all_sync()',
   },
   {
      "mrcjkb/rustaceanvim",
      version = "^6",
      lazy = false,
      ft = { "rust" },
   },

   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup {
            ensure_installed = {
               "vimdoc",
               "javascript",
               "typescript",
               "lua",
               "jsdoc",
               "bash",
               "svelte",
               "go",
               "gomod",
               "gowork",
               "gosum",
               "svelte",
               "astro",
               "css",
               "cpp",
               "cmake",
               "cmake",
               "html",
               "json",
               "jsonc",
               "markdown",
               "markdown_inline",
               "python",
               "regex",
               "rust",
               "toml",
               "yaml",
            },
            sync_install = false,
            auto_install = true,
            indent = {
               enable = false,
            },

            fold = { enable = false },
            highlight = {
               enable = true,
               disable = function(lang, buf)
                  if lang == "html" then
                     print "disabled"
                     return true
                  end

                  local max_filesize = 100 * 1024 -- 100 KB
                  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                  if ok and stats and stats.size > max_filesize then
                     return true
                  end
               end,

               additional_vim_regex_highlighting = { "markdown" },
            },
         }
      end,
   },
   {
      "ibhagwan/fzf-lua",
      opts = {
         winopts = {
            height = 0.35,
            width = 0.80,
            preview = {
               hidden = "hidden",
               layout = "vertical",
            },
         },
         fzf_opts = {
            ["--ansi"] = "",
            ["--prompt"] = "🔍 ",
         },
      },
   },

   {
      "folke/which-key.nvim",
      enabled = false,
   },
   {
      "nvim-telescope/telescope.nvim",
      enabled = false,
   },
   {
      {
         "Civitasv/cmake-tools.nvim",
         name = "cmake-tools.nvim",
         lazy = true,
         init = function()
            local function try_load()
               if vim.fn.filereadable(vim.fn.getcwd() .. "/CMakeLists.txt") == 1 then
                  require("lazy").load { plugins = { "cmake-tools.nvim" } }
               end
            end
            try_load()
            vim.api.nvim_create_autocmd({ "DirChanged", "BufReadPost" }, {
               pattern = "*",
               callback = try_load,
            })
         end,
         opts = {}, -- lazy.nvim bakal auto-setup(opts)
      },
      {
         "p00f/clangd_extensions.nvim",
         lazy = true,
         ft = { "c", "cpp", "objc", "objcpp" },
         opts = {
            inlay_hints = { inline = false },
            ast = {
               role_icons = {
                  type = "",
                  declaration = "",
                  expression = "",
                  specifier = "",
                  statement = "",
                  ["template argument"] = "",
               },
               kind_icons = {
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
               },
            },
         },
      },
   },
   {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
         local cmp = require "cmp"
         local custom = {
            mapping = {
               ["<CR>"] = cmp.mapping.confirm { select = true }, -- enter buat confirm pilihan
               ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
               ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            },
            sources = cmp.config.sources {
               { name = "nvim_lsp",   priority = 1000 },
               { name = "luasnip",    priority = 750 },
               { name = "async_path", priority = 250 }, -- For luasnip users.
            },
            completion = {
               completeopt = "menu,menuone,noselect",
            },
            preselect = cmp.PreselectMode.None,
         }
         return vim.tbl_deep_extend("force", opts, custom)
      end,
   },
}
