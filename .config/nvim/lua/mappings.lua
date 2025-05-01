require "nvchad.mappings"

local map = vim.keymap.set

--accept copilot suggestion

map("n", "<leader>tr", "<cmd> RenderMarkdown toggle<CR>", { desc = "Toggle Rendering markdown" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>srr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace" })
map(
  "n",
  "<leader>scc",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]],
  { desc = "Search & replace with confirm" }
)

map("n", "mm", "mM", { desc = "Mark file" })
map("n", "M", "`M", { desc = "Jump to marked file" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg<S-v>G", { desc = "Select all" })
