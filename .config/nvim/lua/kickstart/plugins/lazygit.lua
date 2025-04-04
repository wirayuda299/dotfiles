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
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
  config = function()
    -- Set floating window options for lazygit
    vim.g.lazygit_floating_window_winblend = 0 -- No transparency
    vim.g.lazygit_floating_window_scaling_factor = 1.0 -- Full scale window
    vim.g.lazygit_floating_window_border = 'rounded' -- Rounded border for better look

    -- Use Neovim's built-in terminal for running lazygit
    vim.g.lazygit_use_neovim_terminal = 1
  end,
}
