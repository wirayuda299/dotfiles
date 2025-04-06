local keymap = vim.keymap.set

keymap('n', '<C-n>', vim.cmd.Ex)

--move up/down
keymap({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
--search
keymap('n', '<leader>sr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap('n', '<leader>sc', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]])
keymap('n', '<leader>r', ':%s///g<Left><Left><Left>', { desc = 'Fast replace' })

-- focus
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

keymap('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
keymap('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
keymap('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
keymap('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

keymap('n', '<leader>bd', ':bp | bd #<CR>', { noremap = true, silent = true })
keymap('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap('n', '<BS>', '<C-^>', { noremap = true, silent = true })

keymap('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers except current' })
keymap('n', '<leader>bc', '<cmd>:%bd!<cr>', { desc = 'Close all buffers' })
-- Use H and L to switch between buffers (like moving between words)
keymap('n', 'H', ':bp<CR>', { noremap = true, silent = true }) -- Previous buffer
keymap('n', 'L', ':bn<CR>', { noremap = true, silent = true }) -- Next buffer

--lazy
keymap('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })

keymap('n', '<C-c>', '"+yy', { desc = 'Copy current line to system clipboard' })
keymap('v', '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
keymap('n', '<C-P>', '"+p', { desc = 'Paste from system clipboard' })

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
vim.keymap.set('n', 'mm', 'mM', { desc = 'Mark file' })
vim.keymap.set('n', 'M', '`M', { desc = 'Jump to marked file' })

--select all
keymap('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })
keymap('i', '<C-a>', '<Esc>gg<S-v>G', { desc = 'Select all' })

keymap({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
--add to quickfix list
keymap('n', '<leader>a', '<cmd>cadd %<cr>', { desc = 'Add to Quickfix List' })

keymap('n', '<leader>p', vim.cmd.cprev, { desc = 'Previous Quickfix' })
keymap('n', '<leader>n', vim.cmd.cnext, { desc = 'Next Quickfix' })
