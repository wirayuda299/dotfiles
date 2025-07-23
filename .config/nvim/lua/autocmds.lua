local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general_group = augroup("General", { clear = true })
local lsp_group = augroup("LSP", { clear = true })
local formatting_group = augroup("Formatting", { clear = true })
local performance_group = augroup("Performance", { clear = true })

-------------------------------------- general autocommands ------------------------------------------
autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end
})

autocmd("VimResized", {
  group = general_group,
  desc = "Auto-resize splits on window resize",
  callback = function()
    vim.schedule(function()
      vim.cmd("wincmd =")
    end)
  end
})

autocmd("FileType", {
  pattern = { "log", "txt", "markdown" },
  callback = function(args)
    vim.defer_fn(function()
      local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf))
      if file_size > 1024 * 1024 then -- 1MB
        local clients = vim.lsp.get_clients({ bufnr = args.buf })
        for _, client in ipairs(clients) do
          vim.lsp.stop_client(client.id)
        end
      end
    end, 100)
  end
})

autocmd("BufReadPost", {
  group = general_group,
  desc = "Restore cursor position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
  group = general_group,
  desc = "Close certain filetypes with 'q'",
  pattern = {
    "help", "lspinfo", "man", "checkhealth", "qf", "query",
    "notify", "tsplayground", "spectre_panel", "startuptime", "oil", "dadbod"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end
})

-- Disable formatoptions for all filetypes
autocmd("FileType", {
  group = general_group,
  desc = "Disable auto-commenting",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
})

-- Auto-save when focus is lost
autocmd("FocusLost", {
  group = general_group,
  desc = "Auto-save on focus lost",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! wall")
    end
  end,
})

-- Close quickfix with last window
autocmd("WinEnter", {
  group = general_group,
  desc = "Close quickfix if it's the last window",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
      vim.cmd("q")
    end
  end,
})

-------------------------------------- lsp autocommands ------------------------------------------
autocmd("LspAttach", {
  group = lsp_group,
  desc = "LSP keymaps and configuration",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local map = require("utils").map
    require("utils").diagnostics()


    map('gd', vim.lsp.buf.definition, 'Goto Definition', 'n', bufnr)
    map('gr', vim.lsp.buf.references, 'Goto References', 'n', bufnr)
    map('gI', vim.lsp.buf.implementation, 'Goto Implementation', 'n', bufnr)
    map('gy', vim.lsp.buf.type_definition, 'Type Definition', 'n', bufnr)
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration', 'n', bufnr)
    map('K', vim.lsp.buf.hover, 'Hover Documentation', 'n', bufnr)
    map('gK', vim.lsp.buf.signature_help, 'Signature Documentation', 'n', bufnr)
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', 'i', bufnr)
    map('<leader>rn', vim.lsp.buf.rename, 'Rename', 'n', bufnr)
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', 'n', bufnr)

    map('<leader>f', function()
      vim.lsp.buf.format({
        async = true,
        bufnr = bufnr,
        filter = function(c)
          return c.id == client.id
        end
      })
    end, 'Format', 'n', bufnr)

    map('[d', function()
      vim.diagnostic.jump({ float = true, count = -1 })
    end, 'Previous Diagnostic', 'n', bufnr)

    map(']d', function()
      vim.diagnostic.jump({ float = true, count = 1 })
    end, 'Next Diagnostic', 'n', bufnr)
  end,
})

-------------------------------------- formatting autocommands ------------------------------------------
-- Format on save for specific filetypes
autocmd("BufWritePre", {
  group = formatting_group,
  desc = "Format on save",
  pattern = { "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx", "*.go", "*.json" },
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({
          bufnr = args.buf,
          async = false, -- Changed to false to ensure completion before save
          timeout_ms = 2000,
          filter = function(c)
            return c.id == client.id
          end
        })
        break
      end
    end
  end,
})

-------------------------------------- performance autocommands ------------------------------------------
autocmd({ "BufReadPre", "FileReadPre" }, {
  group = performance_group,
  desc = "Disable features for large files",
  callback = function()
    local file = vim.fn.expand("%")
    local file_size = vim.fn.getfsize(file)

    if file_size > 1024 * 1024 then -- 1MB
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
      vim.opt_local.syntax = "off"
      vim.opt_local.filetype = ""
    end
  end,
})

-- Faster macro execution
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

-- User command for diagnostic list
vim.api.nvim_create_user_command("DiagnosticList", vim.diagnostic.setqflist, { bang = true })
