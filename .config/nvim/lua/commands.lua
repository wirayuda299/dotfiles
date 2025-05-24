vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.highlight or vim.hl).on_yank { timeout = 200 }
  end,
})
