require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<leader><leader>", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
map("x", "<leader>p", [["_dP]])
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map({ "n", "v" }, "<leader>d", [["_d]])
map("i", "<C-c>", "<Esc>", { desc = "Normal mode" })
map("n", "Q", "<nop>")
map("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace" })
map('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
map('i', '<C-s>', '<C-o>:w<CR>', { noremap = true, silent = true })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save" })
