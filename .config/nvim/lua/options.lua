require "nvchad.options"
-- A set of options for better completion experience. See `:h completeopt`
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

-- Hides the ins-completion-menu messages. See `:h shm-c`
vim.opt.shortmess:append "c"
vim.opt.updatetime = 500
vim.opt.wrap = false
vim.opt.laststatus = 3
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.o.relativenumber = true
vim.o.number = true

vim.opt.linebreak = true -- break at whitespace instead of last character on screen
