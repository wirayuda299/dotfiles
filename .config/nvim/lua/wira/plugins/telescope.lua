return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = vim.fn.executable 'make' == 1,
    },
  },
  config = function()
    local telescope = require 'telescope'

    telescope.setup {
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
          '.svelte-kit',
          '.vercel',
          '.nuxt',
        },
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.5,
          },
          vertical = {
            mirror = false,
          },
          width = 0.8,
          height = 0.8,
        },
      },
      cwd = require('telescope.utils').buffer_dir(),
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--glob',
            '!.git/*',
            '--glob',
            '!.svelte-kit/*',
            '--glob',
            '!node_modules/*',
            '--glob',
            '!dist/*',
            '--glob',
            '!build/*',
            '--glob',
            '!public/*',
          },
        },
        live_grep = {
          additional_args = { '--hidden' },
        },
      },
    }

    -- Load the fzf extension
    telescope.load_extension 'fzf'

    -- Keymaps
    local builtin = require 'telescope.builtin'
    local keymap = require 'utils.keymaps'

    keymap.safe_keymap('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
    keymap.safe_keymap('n', '<C-g>', builtin.git_files, { desc = 'Find git files' })
    keymap.safe_keymap('n', '<A-f>', function()
      local word = vim.fn.expand '<cword>'
      builtin.grep_string { search = word }
    end, { desc = 'Grep word' })
    keymap.safe_keymap('n', '<leader>gr', function()
      builtin.help_tags { search = vim.fn.input 'Grep > ' }
    end, { desc = 'Grep help tags' })
    keymap.safe_keymap('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>', { desc = 'Find Buffers' })
    keymap.safe_keymap('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>', { desc = 'Workspace Diagnostics' })
    keymap.safe_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics bufnr=0<cr>', { desc = 'Document Diagnostics' })
    keymap.safe_keymap('n', '<leader>q', '<cmd>Telescope quickfix<cr>', { desc = 'Quickfix List' })
  end,
}
