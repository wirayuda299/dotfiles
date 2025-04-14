vim.g.mapleader = ' '
vim.opt.guicursor = {
  'n-v-c:block', -- Normal, visual, command: block
  'i-ci:ver25', -- Insert and Insert-command: vertical bar
  'r-cr:hor20', -- Replace and Command Replace: underscore
  'o:hor50', -- Operator-pending
  'a:blinkon0', -- No blinking
}

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = ' '
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2'
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.foldmethod = 'manual'
vim.opt.foldexpr = ''
vim.opt.foldenable = false
vim.opt.foldcolumn = '0'
