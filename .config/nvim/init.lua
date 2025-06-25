vim.loader.enable()

vim.g.mapleader = " "

require("config.core.lsp").defaults()
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
