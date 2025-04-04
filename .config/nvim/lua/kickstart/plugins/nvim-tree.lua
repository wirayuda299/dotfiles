return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 35,
        side = 'left',
        adaptive_size = true,
      },

      renderer = {
        special_files = {},
        root_folder_label = true,
        highlight_opened_files = 'all',
        highlight_modified = 'all',
        full_name = false,
        indent_width = 2,
        add_trailing = true,
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            symlink = '',
            default = '󰈙',
            folder = {
              arrow_closed = '',
              arrow_open = '',
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
              symlink_open = '',
            },
            git = {
              unstaged = '',
              staged = '',
              unmerged = '',
              renamed = '',
              untracked = '',
              deleted = '',
              ignored = '◌',
            },
          },
        },
        indent_markers = {
          enable = true,
          icons = {
            corner = '└',
            edge = '│',
            item = '├',
            bottom = '─',
            none = ' ',
          },
        },
      },

      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
    }
  end,
}
