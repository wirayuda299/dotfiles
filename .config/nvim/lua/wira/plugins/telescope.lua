return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = {
          'node_modules',
          'dist',
          'build',
          'public',
          'static',
          'tmp',
          '*.log',
          '*.tmp',
          '*.temp',
          '*.lock',
          '.git',
          '.gitignore',
          '.next',
        },

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      },

      pickers = {
        find_files = {
          hidden = true,
        },
      },
    }

    local builtin = require 'telescope.builtin'
    local keymap = require 'utils.keymaps'

    keymap.safe_keymap('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
    keymap.safe_keymap('n', '<C-g>', builtin.git_files, { desc = 'Find git files' })
    keymap.safe_keymap('n', '<A-f>', function()
      local word = vim.fn.expand '<cword>'
      builtin.grep_string { search = word }
    end)
    keymap.safe_keymap('n', '<leader>gr', function()
      builtin.help_tags { search = vim.fn.input 'Grep > ' }
    end)

    keymap.safe_keymap('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>', { desc = 'Find Buffers' })
    keymap.safe_keymap('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = 'Workspace Diagnostics' })
    keymap.safe_keymap('n', '<leader>sD', '<cmd>Telescope diagnostics bufnr=0<cr>', { desc = 'Document Diagnostics' })
    keymap.safe_keymap('n', '<leader>q', '<cmd>Telescope quickfix<cr>', { desc = 'Quickfix List' })
  end,
}
