return {
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

      local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      treesitter_parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      vim.treesitter.language.register("templ", "templ")
    end,
  },
}
