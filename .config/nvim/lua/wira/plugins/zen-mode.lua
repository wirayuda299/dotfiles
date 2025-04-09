return {
  {
    'folke/zen-mode.nvim',
    dependencies = {
      'folke/twilight.nvim',
    },
    config = function()
      local keymap = require 'utils.keymaps'
      keymap.safe_keymap('n', '<leader>zZ', function()
        require('zen-mode').setup {
          window = {
            width = 120,
            options = {
              number = false,
              relativenumber = false,
              list = false,
              signcolumn = 'no',
            },
            backdrop = 0.95,
          },
          plugins = {
            twilight = { enable = true },
          },
        }
        require('zen-mode').toggle()

        vim.wo.wrap = not false
        vim.wo.number = not false
        vim.wo.rnu = not false
        vim.opt.colorcolumn = '0'
      end, { desc = 'Toogle zen mode' })
    end,
  },
  {
    'folke/twilight.nvim',
    opts = {
      dimming = {
        alpha = 0.50,
        inactive = true,
        active = true,
      },
      context = 10,
    },
  },
}
