vim.loader.enable()

vim.g.mapleader = " "
vim.defer_fn(function()
    require("config.core.lsp").defaults()
end, 100)

require("config.core.options")
require("config.core.autocmds")

vim.schedule(function()
    require("config.core.keymaps")
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", require("config.core.lazy"))
