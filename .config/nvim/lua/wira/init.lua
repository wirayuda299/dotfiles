require 'wira.options'
require 'wira.keymaps'

require 'wira.lazy_init'

local augroup = vim.api.nvim_create_augroup
local WiraGroup = augroup('Wira', {})

local autocmd = vim.api.nvim_create_autocmd

local highlight_yank = augroup('highlight_yank', {})

autocmd('TextYankPost', {
  group = highlight_yank,
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

autocmd({ 'BufWritePre' }, {
  group = WiraGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})
autocmd('LspAttach', {
  group = WiraGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set('n', 'gd', function()
      vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set('n', '<leader>ws', function()
      vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set('n', '<leader>df', function()
      vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set('n', '<leader>ca', function()
      vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set('n', '<leader>rn', function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set('i', '<C-h>', function()
      vim.lsp.buf.signature_help()
    end, opts)
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.goto_prev()
    end, opts)
  end,
})
