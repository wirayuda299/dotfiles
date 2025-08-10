local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec="plugins",
  defaults = { lazy = true, version = false, event="VeryLazy" },
  install = { colorscheme = {  }, missing = true },
  checker = { enabled = false },
  change_detection = { enabled = false },
  profiling = {
    loader = true,
    require = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin", "editorconfig",
        "synmenu", "optwin", "compiler", "bugreport", "syntax", "nvim-treesitter", "2html_plugin", "ftplugin",
        "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw", "netrwplugin", "spellfile_plugin",
        "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin", "osc52", "shada", "spellfile", "man", "filetype",
      },
    },
  },
})
