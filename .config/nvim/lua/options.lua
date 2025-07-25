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
local o = vim.o
local g = vim.g
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_tarPlugin = 1
g.loaded_gzip = 1
g.loaded_zipPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_shada_plugin = 1
g.loaded_spellfile_plugin = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_tutor_mode_plugin = 1
o.fsync = false
o.swapfile = false
o.backup = false
o.writebackup = false
o.lazyredraw = true
o.ttyfast = true
o.regexpengine = 1
o.maxmempattern = 2000
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
o.showmode = false
o.splitkeep = "screen"
opt.guicursor = {
  "n-v-c:block",      -- Normal, Visual, Command: block cursor
  "i-ci-ve:ver25",    -- Insert, Command Insert, Visual Exclusive: vertical bar cursor with 25% width
  "r-cr:hor20",       -- Replace, Command Replace: horizontal bar cursor with 20% height
  "o:hor50",          -- Operator-pending: thicker horizontal bar
  "a:blinkon100",     -- Enable blinking for all modes (optional)
}
g.use_icons = true    -- Set to false to disable all icons
g.icon_style = "nerd" -- "nerd", "text", or "none"
o.clipboard = "unnamedplus"
o.cursorline = true
-- o.cursorlineopt = "number"
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
opt.sidescroll = 1
opt.sidescrolloff = 5
opt.fillchars = { eob = " " }
opt.shortmess:append "sI"
o.ignorecase = true
o.smartcase = true
o.mouse = "a"
o.synmaxcol = 50 -- Limit syntax highlighting to first 300 columns
o.syntax = "off"
o.number = true
o.numberwidth = 2
o.ruler = false
o.signcolumn = "no"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.updatetime = 50
opt.wrap = false
opt.whichwrap:append "<>[]hl"
opt.hlsearch = true
opt.incsearch = true

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
