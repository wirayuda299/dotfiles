local set_hl = vim.api.nvim_set_hl

set_hl(0, "Normal", { bg = "none" })
set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "SignColumn", { bg = "none" })
set_hl(0, "LineNr", { bg = "none" })
set_hl(0, "CursorLineNr", { bg = "none" })
set_hl(0, "EndOfBuffer", { bg = "none" })
set_hl(0, "StatusLine", { bg = "none" })
set_hl(0, "StatusLineNC", { bg = "none" })
set_hl(0, "WinSeparator", { bg = "none" })


local opt = vim.opt
local o = vim.o
local g = vim.g

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
o.showmode = false
o.splitkeep = "screen"
opt.guicursor = {
  "n-v-c:block",          -- Normal, Visual, Command: block cursor
  "i-ci-ve:ver25",        -- Insert, Command Insert, Visual Exclusive: vertical bar cursor with 25% width
  "r-cr:hor20",           -- Replace, Command Replace: horizontal bar cursor with 20% height
  "o:hor50",              -- Operator-pending: thicker horizontal bar
  "a:blinkon100",         -- Enable blinking for all modes (optional)
}
vim.g.use_icons = true    -- Set to false to disable all icons
vim.g.icon_style = "nerd" -- "nerd", "text", or "none"
-- For init.lua
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2
opt.list = true
opt.cmdheight = 0

opt.listchars = {
  tab = "│ ", -- Show tabs as vertical line + space
  leadmultispace = "│" .. string.rep(" ", vim.o.shiftwidth - 1), -- Show leading spaces as indent guides
}
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 5
opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"
o.number = true
o.numberwidth = 2
o.ruler = false
opt.shortmess:append "sI"
o.signcolumn = "no"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.updatetime = 50
opt.wrap = false
opt.whichwrap:append "<>[]hl"
opt.hlsearch = false
opt.incsearch = true

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
