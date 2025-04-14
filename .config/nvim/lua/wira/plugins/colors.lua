return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load this before all other start plugins.
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
}
