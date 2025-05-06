vim.g.mapleader = " "

vim.lsp.set_log_level("warn")
vim.g.lsp_utils_cache = true
vim.g.lsp_document_highlight_cache = true
vim.g.lsp_cache_dir = vim.fn.stdpath("cache") .. "/lsp"
vim.fn.mkdir(vim.g.lsp_cache_dir, "p") -- Ensure cache directory exists

vim.loader.enable()

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

local lazy_config = require("plugins.configs.lazy")

require("lazy").setup({
    { import = "plugins" },
}, lazy_config)

require("options")
require("autocmds")

vim.schedule(function()
    require("mappings")
end)
