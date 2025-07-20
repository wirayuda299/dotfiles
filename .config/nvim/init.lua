vim.loader.enable()

vim.g.mapleader = " "


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--single-branch",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")
require("lazy").setup("plugins", lazy_config)

vim.schedule(function()
  require("autocmds")
  require("options")
  require("keymaps")
end)
