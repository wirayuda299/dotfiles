local set_hl = vim.api.nvim_set_hl

set_hl(0, "Normal", { bg = "none" })
set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "LineNr", { bg = "none" })
set_hl(0, "CursorLineNr", { bg = "none" })
set_hl(0, "EndOfBuffer", { bg = "none" })
set_hl(0, "StatusLineNC", { bg = "none" })
set_hl(0, "WinSeparator", { bg = "none" })

local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.encoding = "utf-8"
opt.guicursor = ""
opt.nu = true
opt.relativenumber = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.linebreak = true   -- Break lines at word boundaries
opt.breakindent = true -- Maintain indentation for wrapped lines
opt.guicursor = {
  "n-v-c:block",       -- Normal, Visual, Command: block cursor
  "i-ci-ve:ver25",     -- Insert, Command Insert, Visual Exclusive: vertical bar cursor with 25% width
  "r-cr:hor20",        -- Replace, Command Replace: horizontal bar cursor with 20% height
  "o:hor20",           -- Operator-pending: thicker horizontal bar
}
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "no"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "0"
opt.cmdheight = 0
opt.list = true
opt.listchars = {
  tab = "│ ",
  leadmultispace = "│" .. string.rep(" ", vim.o.shiftwidth - 1), -- Show leading spaces as indent guides
}
opt.fillchars = { eob = " " }
opt.shortmess:append "sI"
