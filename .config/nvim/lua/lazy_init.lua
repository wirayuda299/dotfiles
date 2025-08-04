local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo(
      { { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
      true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

if not pcall(require, "lazy") then
  vim.api.nvim_echo(
    { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

local config = {
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
        "synmenu", "optwin", "compiler", "bugreport", "syntax", "nvim-treesitter", "2html_plugin", "ftplugin",
        "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw", "netrwplugin", "spellfile_plugin",
        "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin", "osc52", "shada", "spellfile", "man", "filetype",
        "shada", "spellfile", "vimball", "zipPlugin" }
    },
  },
}

require("lazy").setup({
  spec = "plugins",
  defaults = config.defaults,
  performance = config.performance,
  install = config.install,
  checker = config.checker,
  change_detection = config.change_detection,

})
