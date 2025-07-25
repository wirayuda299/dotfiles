vim.g.mapleader = " "
pcall(vim.loader.enable)

vim.cmd("syntax off")
vim.opt_local.foldmethod = "manual"

local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none", "--single-branch",
      "https://github.com/folke/lazy.nvim.git", lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

bootstrap_lazy()
require("lazy_init")

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    require("options")
    require("autocmds")
    require("keymaps")
  end,
})
