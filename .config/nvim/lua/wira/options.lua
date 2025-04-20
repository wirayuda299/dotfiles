vim.g.mapleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.guicursor = {
    'n-v-c:block',
    'i-ci:ver25',
    'r-cr:hor20',
    'o:hor50',
    'a:blinkon0',
}
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#000000", bg = "none" })
vim.opt.fillchars:append({ eob = " " })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#3b3b3b", bg = "none" })

vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#7aa2f7", bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#bb9af7", bg = "none", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#565f89", bg = "none" })

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
