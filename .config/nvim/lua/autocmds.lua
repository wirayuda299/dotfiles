local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general_group = augroup("General", { clear = true })
local lsp_group = augroup("LSP", { clear = true })
local formatting_group = augroup("Formatting", { clear = true })
local performance_group = augroup("Performance", { clear = true })


autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end
})

autocmd("FileType", {
  group = general_group,
  desc = "Close certain filetypes with 'q'",
  pattern = {
    "help", "lspinfo", "man", "checkhealth", "qf", "query",
    "notify", "tsplayground", "spectre_panel", "startuptime", "oil", "dadbod",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end
})

autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local bufnr = args.buf

    require("utils").diagnostics()

    local map = require("utils").map
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, { silent = true })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true })

    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ float = true, count = -1 })
    end, { silent = true })

    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ float = true, count = 1 })
    end, { silent = true })
  end,
})

autocmd("BufWritePre", {
  group = formatting_group,
  desc = "Format on save",
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      async = true,
      timeout_ms = 2000,
    })
  end,
})

autocmd("RecordingEnter", {
  group = performance_group,
  desc = "Optimize for macro recording",
  callback = function()
    vim.opt_local.lazyredraw = true
    vim.opt.cmdheight = 1
  end,
})

autocmd("RecordingLeave", {
  group = performance_group,
  desc = "Restore after macro recording",
  callback = function()
    vim.opt_local.lazyredraw = false
    vim.opt.cmdheight = 0
  end,
})
