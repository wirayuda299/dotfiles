require 'wira.options'
require 'wira.keymaps'
require 'wira.lazy_init'

local augroup = vim.api.nvim_create_augroup
local WiraGroup = augroup('Wira', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufWritePre', {
  group = WiraGroup,
  pattern = '*',
  callback = function(args)
    local view = vim.fn.winsaveview()
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.winrestview(view)

    require('conform').format {
      bufnr = args.buf,
      async = true,
      lsp_fallback = true,
      timeout_ms = 3000,
    }
  end,
})

autocmd('ColorScheme', {
  callback = function()
    vim.cmd [[
      highlight DiagnosticVirtualTextError guifg=#F38BA8 gui=bold
      highlight DiagnosticVirtualTextWarn  guifg=#F9E2AF gui=bold
      highlight DiagnosticVirtualTextInfo  guifg=#89B4FA gui=bold
      highlight DiagnosticVirtualTextHint  guifg=#94E2D5 gui=italic
      highlight! link FloatBorder NormalFloat
      highlight! NormalFloat guibg=#1E1E2E
  highlight! FloatTitle guifg=#89B4FA gui=bold
    ]]
  end,
})

autocmd('TextYankPost', {
  group = WiraGroup,
  callback = function()
    (vim.highlight or vim.hl).on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = WiraGroup,
  callback = function(e)
    local bufnr = e.buf
    local opts = { buffer = bufnr }

    -- LSP document highlight
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = WiraGroup,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = WiraGroup,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    -- Keymaps for LSP
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end,
})

autocmd('LspDetach', {
  group = augroup('kickstart-lsp-detach', { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()
    vim.api.nvim_clear_autocmds {
      group = WiraGroup,
      buffer = event.buf,
    }
  end,
})
