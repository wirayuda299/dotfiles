local set_hl = vim.api.nvim_set_hl
local opt = vim.opt

set_hl(0, "Normal", { bg = "none" })
set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "LineNr", { bg = "none" })
set_hl(0, "CursorLineNr", { bg = "none" })
set_hl(0, "EndOfBuffer", { bg = "none" })
set_hl(0, "StatusLineNC", { bg = "none" })
set_hl(0, "WinSeparator", { bg = "none" })


opt.clipboard = "unnamedplus"
opt.encoding = "utf-8"
opt.guicursor = ""
opt.nu = true
opt.relativenumber = false
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.guicursor = {
  "n-v-c:block",   -- Normal, Visual, Command: block cursor
  "i-ci-ve:ver25", -- Insert, Command Insert, Visual Exclusive: vertical bar cursor with 25% width
  "r-cr:hor20",    -- Replace, Command Replace: horizontal bar cursor with 20% height
  "o:hor20",       -- Operator-pending: thicker horizontal bar
}
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 10
opt.signcolumn = "no"
opt.isfname:append("@-@")
opt.updatetime = 500
opt.colorcolumn = "0"
opt.cmdheight = 0
opt.list = true
opt.listchars = {
  tab = "│ ",
  leadmultispace = "│" .. string.rep(" ", vim.o.shiftwidth - 1),
}
opt.fillchars = { eob = " " }
opt.shortmess:append "sI"
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

