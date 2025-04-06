return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load this before all other start plugins.
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
    
  end,
}
