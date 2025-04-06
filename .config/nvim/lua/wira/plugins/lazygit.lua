return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
  config = function()
    vim.g.lazygit_floating_window_winblend = 0 -- No transparency
    vim.g.lazygit_floating_window_scaling_factor = 1.0 -- Full scale window
    vim.g.lazygit_floating_window_border = 'rounded' -- Rounded border for better look
    vim.g.lazygit_use_neovim_terminal = 1
  end,
}
