local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*",
    callback = function()
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"
        vim.bo.buflisted = false
    end,
})

-- Performance optimizations
local perf = augroup("Performance", { clear = true })
autocmd("BufEnter", {
    group = perf,
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Highlight on yank
autocmd("TextYankPost", {
    group = augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
    end,
})

-- Restore cursor position
autocmd("BufReadPost", {
    group = augroup("RestoreCursor", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto resize splits
autocmd("VimResized", {
    group = augroup("AutoResize", { clear = true }),
    command = "tabdo wincmd =",
})

-- Close with q
autocmd("FileType", {
    group = augroup("QuickClose", { clear = true }),
    pattern = { "qf", "help", "man", "lspinfo", "checkhealth", "spectre_panel" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_user_command("NpmShow", function()
    require("package-info").show({ force = true })
end, { desc = "Show npm package info (forced)" })
-- Auto save
autocmd({ "BufLeave", "FocusLost" }, {
    group = augroup("AutoSave", { clear = true }),
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.api.nvim_command("silent update")
        end
    end,
})

-- Set filetype for specific files
autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("FileTypeDetect", { clear = true }),
    pattern = { "*.env*", "*.conf", "*.ini" },
    command = "setfiletype conf",
})
