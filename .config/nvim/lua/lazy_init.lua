local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "plugins",
    defaults = { lazy = true, version = false, },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = false },
    change_detection = { enabled = false },
    performance = {
        cache = { enabled = true },
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin", "editorconfig",
                "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "syntax", "nvim-treesitter",
                "2html_plugin", "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw",
                "netrwplugin", "spellfile_plugin", "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin", "osc52",
                "shada",
                "spellfile", "man", "filetype", "shada", "spellfile", "vimball", "zipPlugin" }
        },
    },
})
