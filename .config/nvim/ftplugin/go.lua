local map = vim.keymap.set
map("n", "<leader>fs", "<cmd>GoFillStruct<cr>", { desc = "Fill struct" })
map("n", "<leader>at", "<cmd>GoAddTag<cr>", { desc = "Add JSON tag" })
map("n", "<leader>rt", "<cmd>GoRmTag<cr>", { desc = "Remove JSON tag" })
map("n", "<leader>ee", "<cmd>GoIfErr<cr>", { desc = "If error" })
map("n", "<leader>R", "<cmd>GoRename<cr>", { desc = "Rename" })
map("n", "<leader>I", "<cmd>GoImpl<cr>", { desc = "Implement" })
map("n", "<leader>fp", "<cmd>GoFixPlurals<cr>", { desc = "Fix plurals" })

map("n", "<leader>ci", "<cmd>GoCmt<cr>", { desc = "Generate comments" })
map("n", "<leader>gd", "<cmd>GoMod tidy<cr>", { desc = "Go mod tidy" })
map("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Go Run" })
