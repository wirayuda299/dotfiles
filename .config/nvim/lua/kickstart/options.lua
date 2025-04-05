vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.g.loaded_netrwPlugin = 0
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakat = ' \t'
vim.opt.breakindentopt = 'shift:2'
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.conceallevel = 2
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
--remove padding
vim.opt.fillchars = { eob = ' ' }
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.cmdheight = 1
vim.opt.shortmess:append { W = true, I = true, c = true }
vim.opt.background = 'dark'
vim.opt.showtabline = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.showmatch = true
