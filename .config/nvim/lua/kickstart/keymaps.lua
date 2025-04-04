local keymap = vim.keymap.set

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

--move up/down
keymap({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

--search
keymap('n', '<leader>sr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap('n', '<leader>sc', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]])

-- focus
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--tab
keymap('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
keymap('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })

keymap('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })

keymap('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers except current' })
--lazy
keymap('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })

keymap('n', '<C-c>', '"+yy', { desc = 'Copy current line to system clipboard' })

--obsidian
keymap('n', '<leader>oq', ':ObsidianQuickSwitch<CR>', { noremap = true, silent = true })
keymap('n', '<leader>on', ':ObsidianNew ', { noremap = true, silent = false, desc = 'Create New Obsidian Note' })

keymap('n', ']d', diagnostic_goto(true), { desc = 'Next [D]iagnostic' })
keymap('n', '[d', diagnostic_goto(false), { desc = 'Previous [D]iagnostic' })

--go to next/prev errors
keymap('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next [E]rror' })
keymap('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Previous [E]rror' })

--go to next/prev warnings
keymap('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next [W]arning' })
keymap('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Previous [W]arning' })

--go to next/prev hint_virtual_texts
keymap('n', ']h', diagnostic_goto(true, 'HINT'), { desc = 'Next [H]int' })
keymap('n', '[h', diagnostic_goto(false, 'HINT'), { desc = 'Previous [H]int' })

--go to next/prev information
keymap('n', ']i', diagnostic_goto(true, 'INFO'), { desc = 'Next [I]nfo' })
keymap('n', '[i', diagnostic_goto(false, 'INFO'), { desc = 'Previous [I]nfo' })

--move lines up/down
keymap({ 'n', 'v' }, '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
keymap({ 'n', 'v' }, '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })

--move lines up/down in insert mode
keymap('i', '<A-k>', '<Esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
keymap('i', '<A-j>', '<Esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })

-- select with shift + arrow keys
keymap('n', '<S-Up>', 'V<Up>', { desc = 'Select up' })
keymap('n', '<S-Down>', 'V<Down>', { desc = 'Select down' })
keymap('n', '<S-Left>', 'V<Left>', { desc = 'Select left' })
keymap('n', '<S-Right>', 'V<Right>', { desc = 'Select right' })

-- select with shift + arrow keys in visual mode
keymap('v', '<S-Up>', 'V<Up>', { desc = 'Select up' })
keymap('v', '<S-Down>', 'V<Down>$', { desc = 'Select down' })
keymap('v', '<S-Left>', 'V<Left>', { desc = 'Select left' })
keymap('v', '<S-Right>', 'V<Right>', { desc = 'Select right' })

-- select with shift + arrow keys in insert mode
keymap('i', '<S-Up>', '<Esc>V<Up>', { desc = 'Select up' })
keymap('i', '<S-Down>', '<Esc>V<Down>$', { desc = 'Select down' })
keymap('i', '<S-Left>', '<Esc>V<Left>', { desc = 'Select left' })
keymap('i', '<S-Right>', '<Esc>V<Right>', { desc = 'Select right' })

-- select with shift + arrow keys in select mode
keymap('s', '<S-Up>', 'V<Up>', { desc = 'Select up' })
keymap('s', '<S-Down>', 'V<Down>$', { desc = 'Select down' })
keymap('s', '<S-Left>', 'V<Left>', { desc = 'Select left' })
keymap('s', '<S-Right>', 'V<Right>', { desc = 'Select right' })

--nvimtree toggle
keymap('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle NvimTree' })

--select all
keymap('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })
keymap('i', '<C-a>', '<Esc>gg<S-v>G', { desc = 'Select all' })

--save file
keymap({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

--reload
keymap('n', '<leader>r', '<cmd>source %<cr>', { desc = 'Reload current file' })

keymap('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

keymap('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
keymap('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })
