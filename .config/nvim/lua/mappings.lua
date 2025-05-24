local map = vim.keymap.set

-- general mappings

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })
map({ "n", "v" }, "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("i", "jk", "<ESC>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-- nvimtree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>")

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end)

map("n", "<tab>", ":bnext<CR>", { desc = "buffer goto next" })
map("n", "<S-tab>", ":bprevious<CR>", { desc = "buffer goto prev" })
map("n", "<leader>ba", ":bufdo bd<CR>", { desc = "Close all buffers" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close other buffers" })

map("n", "<leader>x", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local alt = vim.fn.bufnr("#") -- buffer sebelumnya
  if vim.api.nvim_buf_is_valid(alt) and vim.api.nvim_buf_get_option(alt, "buflisted") then
    vim.cmd("buffer " .. alt)
  else
    vim.cmd("bnext")
  end
  vim.cmd("bdelete " .. bufnr)
end, { desc = "Close buffer without leaving to file explorer" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>srr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace" })

map("n", "mm", "mM", { desc = "Mark file" })
map("n", "M", "`M", { desc = "Jump to marked file" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg<S-v>G", { desc = "Select all" })
