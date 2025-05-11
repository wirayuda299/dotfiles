local augroup = vim.api.nvim_create_augroup
local WiraGroup = augroup("Wira", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
   group = WiraGroup,
   callback = function()
      (vim.highlight or vim.hl).on_yank()
   end,
})
autocmd("LspAttach", {
   group = WiraGroup,
   callback = function(e)
      local opts = { buffer = e.buf }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
   end,
})

autocmd("LspDetach", {
   group = augroup("kickstart-lsp-detach", { clear = true }),
   callback = function(e)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds {
         group = WiraGroup,
         buffer = e.buf,
      }
   end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
   pattern = "*",
   command = "set nopaste",
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = { "json", "jsonc", "markdown" },
   callback = function()
      vim.opt.conceallevel = 0
   end,
})
