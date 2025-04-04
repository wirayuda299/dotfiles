return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load this before all other start plugins.
  opts = {
    integrations = { blink_cmp = true },
  },
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
