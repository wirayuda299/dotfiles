require 'wira.options'
require 'wira.keymaps'

require 'wira.lazy_init'

local augroup = vim.api.nvim_create_augroup
local WiraGroup = augroup('Wira', {})
local keymap = require 'utils.keymaps'
local autocmd = vim.api.nvim_create_autocmd

local highlight_yank = augroup('highlight_yank', {})

autocmd('TextYankPost', {
  group = highlight_yank,
  callback = function()
    (vim.highlight or vim.hl).on_yank()
  end,
})

autocmd({ 'BufWritePre' }, {
  group = WiraGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})
autocmd('LspAttach', {
  group = WiraGroup,
  callback = function()
    keymap.safe_keymap('n', 'gd', function()
      vim.lsp.buf.definition { reuse_win = true }
    end, { desc = 'go to definition' })

    keymap.safe_keymap('n', 'gr', function()
      vim.lsp.buf.references { reuse_win = true }
    end, { desc = 'go to references', nowait = true })
    keymap.safe_keymap('n', 'K', function()
      vim.lsp.buf.hover { reuse_win = true }
    end, { desc = 'hover' })
    keymap.safe_keymap('n', '<leader>ws', function()
      vim.lsp.buf.workspace_symbol { reuse_win = true }
    end, { desc = 'workspace symbol' })
    keymap.safe_keymap('n', '<leader>df', function()
      vim.diagnostic.open_float { reuse_win = true }
    end, { desc = 'open float' })
    keymap.safe_keymap('n', '<leader>ca', function()
      vim.lsp.buf.code_action { reuse_win = true }
    end, { desc = 'code action' })
    keymap.safe_keymap('n', '<leader>rn', function()
      vim.lsp.buf.rename { reuse_win = true }
    end, { desc = 'rename' })
    keymap.safe_keymap('i', '<C-h>', function()
      vim.lsp.buf.signature_help { reuse_win = true }
    end, { desc = 'signature help' })
    keymap.safe_keymap('n', '[d', function()
      vim.diagnostic.goto_next { reuse_win = true }
    end, { desc = 'next diagnostic' })
    keymap.safe_keymap('n', ']d', function()
      vim.diagnostic.goto_prev { reuse_win = true }
    end, { desc = 'previous diagnostic' })
  end,
})
