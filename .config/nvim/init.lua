require 'kickstart.options'
require 'kickstart.keymaps'
require 'kickstart.autocmds'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',

  { import = 'kickstart.plugins.mini' },
  { import = 'kickstart.plugins.colors' },
  { import = 'kickstart.plugins.lazydev' },
  { import = 'kickstart.plugins.bufferline' },
  { import = 'kickstart.plugins.blink' },
  { import = 'kickstart.plugins.mason' },
  { import = 'kickstart.plugins.indent_line' },
  { import = 'kickstart.plugins.which-key' },
  { import = 'kickstart.plugins.fzf' },
  { import = 'kickstart.plugins.lint' },
  { import = 'kickstart.plugins.autopairs' },
  { import = 'kickstart.plugins.nvim-tree' },
  { import = 'kickstart.plugins.gitsigns' },
  { import = 'kickstart.plugins.lazygit' },
  { import = 'kickstart.plugins.trouble' },
  { import = 'kickstart.plugins.lsp' },
  { import = 'kickstart.plugins.conform' },
  { import = 'kickstart.plugins.treesitter' },
  { import = 'kickstart.plugins.markdown' },
  { import = 'kickstart.plugins.obsidian' },
}, {

  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
    border = 'rounded',
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
