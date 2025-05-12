local augroup = vim.api.nvim_create_augroup
local WiraGroup = augroup("Wira", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = WiraGroup,
  callback = function()
    (vim.highlight or vim.hl).on_yank { timeout = 200 }
  end,
})

autocmd("LspAttach", {
  group = WiraGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>df", vim.diagnostic.open_float, opts)
    map("n", "[d", vim.diagnostic.goto_prev, opts)
    map("n", "]d", vim.diagnostic.goto_next, opts)
    map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  end,
})

autocmd("LspDetach", {
  group = WiraGroup,
  callback = function(e)
    vim.api.nvim_clear_autocmds {
      group = WiraGroup,
      buffer = e.buf,
    }
  end,
})

autocmd("FileType", {
  group = WiraGroup,
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
