local map = vim.keymap.set
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "g,", "g,zvzz")
map("n", "g;", "g;zvzz")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set("n", "Q", "<nop>")
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg<S-v>G", { desc = "Select all" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace" })

map("n", "mm", "mM", { desc = "Mark file" })
map("n", "M", "`M", { desc = "Jump to marked file" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map({ "n", "x" }, "<leader>fm", function()
    require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "general format file" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map("n", "<leader>km", "<cmd>Telescope keymaps<cr>", { desc = "List all keymaps" })
map("n", "<leader>ql", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix list" })

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Prev Buffer" })


local function smart_delete(dir)
    -- dir = 'prev' atau 'next'
    local cur = vim.api.nvim_get_current_buf()
    local alt = vim.fn.bufnr('#') -- alternate buffer
    local target

    if dir == 'prev' then
        target = alt
    elseif dir == 'next' then
        -- cari buffer setelah, pake bnext logic:
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        for i, b in ipairs(bufs) do
            if b.bufnr == cur then
                target = bufs[i + 1] and bufs[i + 1].bufnr or nil
                break
            end
        end
    end

    if target and vim.api.nvim_buf_is_loaded(target) then
        vim.cmd('buffer ' .. target)
    else
        vim.cmd('enew') -- buka empty buffer baru
    end

    vim.api.nvim_buf_delete(cur, { force = true })
end

-- keymaps
vim.keymap.set('n', '<leader>bp', function() smart_delete('prev') end, { desc = 'Delete Buffer (prev fallback)' })
vim.keymap.set('n', '<leader>bn', function() smart_delete('next') end, { desc = 'Delete Buffer (next fallback)' })

map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Only This Buffer" })

for i = 1, 9 do
    map("n", "<leader>" .. i, "<cmd>buffer " .. i .. "<CR>", { desc = "Go to Buffer " .. i })
end
