local map = require 'utils.keymaps'

map.safe_keymap('n', '<C-n>', vim.cmd.Ex)

map.safe_keymap('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true, timeout_ms = 3000 }
end)

function CreateFileOrFolder()
  local current_dir = vim.fn.expand '%:p:h'
  if vim.fn.isdirectory(current_dir) == 0 then
    current_dir = vim.fn.expand '%:p:h'
  end

  local name = vim.fn.input 'Enter file or folder name: '

  if name:match '/$' then
    local folder_path = current_dir .. '/' .. name
    vim.fn.mkdir(folder_path) -- Create folder
    local current_dir = vim.fn.getcwd()  -- Get the current working directory
  vim.cmd('edit ' .. current_dir)
  else
    local file_path = current_dir .. '/' .. name
    if vim.fn.filereadable(file_path) == 0 then
      vim.cmd('edit ' .. file_path) -- Open file for editing
    else
      print('File already exists: ' .. file_path)
    end
  end
end

vim.cmd [[
  augroup netrw_keymap
    autocmd!
    autocmd FileType netrw nnoremap <buffer> a :lua CreateFileOrFolder()<CR>
  augroup END
]]

map.safe_keymap('n', '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>', { desc = 'Go error handling' })
map.safe_keymap('n', '<leader>km', '<cmd>Telescope keymaps<cr>', { desc = 'Keymaps' })
map.safe_keymap({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map.safe_keymap({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'map'", { desc = 'Up', expr = true, silent = true })
map.safe_keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
map.safe_keymap('n', '<leader>srr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search & replace' })
map.safe_keymap('n', '<leader>scc', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]], { desc = 'Search & replace with confirm' })
map.safe_keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.safe_keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.safe_keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.safe_keymap('n', '<C-map>', '<C-w><C-map>', { desc = 'Move focus to the upper window' })
map.safe_keymap('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map.safe_keymap('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map.safe_keymap('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map.safe_keymap('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })
map.safe_keymap('n', '<leader>bd', ':bp | bd #<CR>', { noremap = true, silent = true, desc = 'Delete buffer' })
map.safe_keymap('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map.safe_keymap('n', '<BS>', '<C-^>', { noremap = true, silent = true, desc = 'Move to last opened buffer' })
map.safe_keymap('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map.safe_keymap('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers except current' })
map.safe_keymap('n', '<leader>bc', '<cmd>:%bd!<cr>', { desc = 'Close all buffers' })
map.safe_keymap('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
map.safe_keymap('n', '<C-c>', '"+yy', { desc = 'Copy current line to system clipboard' })
map.safe_keymap('v', '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
map.safe_keymap('n', '<C-P>', '"+p', { desc = 'Paste from system clipboard' })
map.safe_keymap({ 'n', 'v' }, '<A-map>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map.safe_keymap({ 'n', 'v' }, '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map.safe_keymap('i', '<A-map>', '<Esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
map.safe_keymap('i', '<A-j>', '<Esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
map.safe_keymap('n', 'mm', 'mM', { desc = 'Mark file' })
map.safe_keymap('n', 'M', '`M', { desc = 'Jump to marked file' })
map.safe_keymap('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })
map.safe_keymap('i', '<C-a>', '<Esc>gg<S-v>G', { desc = 'Select all' })
map.safe_keymap({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
map.safe_keymap('n', '<leader>a', '<cmd>cadd %<cr>', { desc = 'Add to Quickfix List' })
map.safe_keymap('n', '<leader>p', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map.safe_keymap('n', '<leader>n', vim.cmd.cnext, { desc = 'Next Quickfix' })
map.safe_keymap('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
map.safe_keymap('n', '<leader>cg', '<cmd>CMakeGenerate<cr>', { desc = 'CMake Generate' })
map.safe_keymap('n', '<leader>cb', '<cmd>CMakeBuild<cr>', { desc = 'CMake Build' })
map.safe_keymap('n', '<leader>cr', '<cmd>CMakeRun<cr>', { desc = 'CMake Run' })
