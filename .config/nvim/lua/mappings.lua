require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map({ "n", "v" }, "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", ":bnext<CR>", { desc = "buffer goto next" })
map("n", "<S-tab>", ":bprevious<CR>", { desc = "buffer goto prev" })
map("n", "<leader>ba", ":bufdo bd<CR>", { desc = "Close all buffers" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close other buffers" })
map("n", "<leader>x", ":bd<CR>", { desc = "buffer close" })

map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

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

local fzf = require "fzf-lua"
local opts = { noremap = true, silent = true }

-- File & buffer
map("n", "<leader>ff", fzf.files, opts) -- semua file (git-ignore aware)
map("n", "<leader>fo", fzf.oldfiles, opts) -- recent files
map("n", "<leader>fb", fzf.buffers, opts) -- buffers

-- Search
map("n", "<leader>fg", fzf.live_grep, opts) -- grep teks
map("n", "<leader>fr", fzf.resume, opts) -- lanjutin session sebelumnya

-- Help & marks
map("n", "<leader>fh", fzf.help_tags, opts) -- help
map("n", "<leader>fm", fzf.marks, opts) -- bookmarks
map("n", "<leader>km", fzf.keymaps, opts) -- bookmarks

-- Git
map("n", "<leader>gs", fzf.git_status, opts) -- status
map("n", "<leader>gf", fzf.git_files, opts) -- file tracked
map("n", "<leader>gc", fzf.git_commits, opts) -- commit history
map("n", "<leader>gb", fzf.git_branches, opts) -- branches
