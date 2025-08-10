local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general_group = augroup("General", { clear = true })
local formatting_group = augroup("Formatting", { clear = true })
local performance_group = augroup("Performance", { clear = true })
local lsp_group = augroup("Lsp", { clear = true })


autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end
})

autocmd("InsertEnter", {
  group = general_group,
  once = true,
  callback = function()
      require("supermaven-nvim").setup({})
  end
})

autocmd("Filetype", {
  pattern ={"dbui"}, 
  callback = function(event)
 local data_path = vim.fn.stdpath("data")
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
    vim.g.db_ui_execute_on_save = false
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
