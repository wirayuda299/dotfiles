vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<C-n>", "<cmd>enew<cr>", { silent = true })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
map("i", "jj", "<ESC>", { silent = true })
map("n", "<C-s>", "<cmd>w<cr>", { silent = true })
map("n", "<C-q>", "<cmd>q<cr>", { silent = true })
map("n", "<leader>x", "<cmd>bdelete<cr>", { silent = true })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg<S-v>G", { desc = "Select all" })
map("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window", remap = true })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("i", "<A-Up>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Down>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current and vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end, { desc = "Close other buffers" })
map('n', '<leader>tw', ':set wrap!<CR>', { desc = 'Toggle wrap' })
