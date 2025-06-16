return {
  {
    'bbjornstad/pretty-fold.nvim',

    config = function(config)
      require('pretty-fold').setup(config['pretty-fold'])
    end,

    defaultConfig = {
      { 'pretty-fold' },
      {

        sections = {
          left = { 'content' },
          right = {
            ' ',
            'number_of_folded_lines',
            ': ',
            'percentage',
            ' ──',
            -- function(config)
            -- 	return config.fill_char:rep(3)
            -- end,
          },
        },

        fill_char = '─', -- ''

        remove_fold_markers = true,

        -- Keep the indentation of the content of the fold string.
        keep_indentation = true,

        -- Possible values:
        -- "delete" : Delete all comment signs from the fold string.
        -- "spaces" : Replace all comment signs with equal number of spaces.
        -- false    : Do nothing with comment signs.
        process_comment_signs = 'spaces',

        -- Comment signs additional to the value of `&commentstring` option.
        comment_signs = {},

        -- List of patterns that will be removed from content foldtext section.
        stop_words = {
          '@brief%s*', -- (for C++) Remove '@brief' and all spaces after.
        },

        add_close_pattern = true, -- true, 'last_line' or false

        matchup_patterns = {
          { '{',  '}' },
          { '%(', ')' }, -- % to escape lua pattern char
          { '%[', ']' }, -- % to escape lua pattern char
        },

        ft_ignore = { 'neorg' },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `LspAttach`
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = "classic",
        transparent_bg = true, -- Set the background of the diagnostic to transparent
        options = {
          add_messages = false,
          throttle = 10,
          overflow = {
            mode = "oneline"
          }
        }
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
    ft = { "html", "javascriptreact", "typescriptreact" },
    event = "VeryLazy",
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    opts = function(_, opts)
      local custom = require "configs.completion"
      return vim.tbl_deep_extend("force", opts, custom)
    end,
  },
}
