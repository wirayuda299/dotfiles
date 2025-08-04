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
    require("utils").diagnostics()
    vim.keymap.set("n", "K", "<cmd>LspUI hover<CR>")
    vim.keymap.set("n", "gr", "<cmd>LspUI reference<CR>")
    vim.keymap.set("n", "gd", "<cmd>LspUI definition<CR>")
    vim.keymap.set("n", "gt", "<cmd>LspUI type_definition<CR>")
    vim.keymap.set("n", "gi", "<cmd>LspUI implementation<CR>")
    vim.keymap.set("n", "<leader>rn", "<cmd>LspUI rename<CR>")
    vim.keymap.set("n", "<leader>ca", "<cmd>LspUI code_action<CR>")
    vim.keymap.set("n", "<leader>ci", "<cmd>LspUI call_hierarchy incoming_calls<CR>")
    vim.keymap.set("n", "<leader>co", "<cmd>LspUI call_hierarchy outgoing_calls<CR>")
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
