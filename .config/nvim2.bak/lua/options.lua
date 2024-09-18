require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = 'both' -- to enable cursorline!
o.relativenumber = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.wrap = true
o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.hlsearch = false
o.incsearch = true
o.termguicolors = true
o.scrolloff = 8
o.signcolumn = "yes"
o.updatetime = 50
o.colorcolumn = "80"
vim.opt.hidden = false
