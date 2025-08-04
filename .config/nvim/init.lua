vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.lsp.set_log_level("ERROR")
    require("options")
    require("autocmds")
    require("keymaps")
  end,
})

require("lazy_init")


