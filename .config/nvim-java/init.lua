vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

local set_hl = vim.api.nvim_set_hl
set_hl(0, "Normal", { bg = "none" })
set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "LineNr", { bg = "none" })
set_hl(0, "CursorLineNr", { bg = "none" })
set_hl(0, "EndOfBuffer", { bg = "none" })
set_hl(0, "StatusLineNC", { bg = "none" })
set_hl(0, "WinSeparator", { bg = "none" })

-- Basic settings
opt.clipboard = "unnamedplus"
opt.encoding = "utf-8"
opt.nu = true
opt.relativenumber = true
opt.tabstop = 4 -- Java uses 4 spaces
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 10
opt.signcolumn = "no"
opt.updatetime = 50
opt.colorcolumn = "0"
opt.cmdheight = 0
opt.syntax = "on"
opt.completeopt = "menuone,noselect"
vim.cmd("cmdheight=0")

vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true })
