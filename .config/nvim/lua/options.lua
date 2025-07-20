vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })


local opt = vim.opt
local o = vim.o
local g = vim.g
-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"
opt.guicursor = ""
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
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
