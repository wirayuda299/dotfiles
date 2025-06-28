local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Buffer management
local buffer_group = augroup("BufferManagement", { clear = true })
autocmd("BufNewFile", {
    group = buffer_group,
    pattern = "*",
    callback = function()
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"
        vim.bo.buflisted = false
    end,
})

-- Performance optimizations - only run once per buffer
local perf = augroup("Performance", { clear = true })
autocmd("BufReadPost", {
    group = perf,
    callback = function()
        -- Only set formatoptions if not already set
        if vim.bo.formatoptions:match("c") then
            vim.opt_local.formatoptions:remove({ "c", "r", "o" })
        end
    end,
})

-- Highlight on yank - optimized
autocmd("TextYankPost", {
    group = augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
    end,
})

-- Restore cursor position - optimized
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

-- Close with q - optimized
autocmd("FileType", {
    group = augroup("QuickClose", { clear = true }),
    pattern = { "qf", "help", "man", "lspinfo", "checkhealth", "spectre_panel" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Auto save - optimized with better conditions
autocmd({ "BufLeave", "FocusLost" }, {
    group = augroup("AutoSave", { clear = true }),
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.bo.buftype
        local readonly = vim.bo.readonly
        local modified = vim.bo.modified

        if modified and not readonly and bufname ~= "" and buftype == "" then
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

autocmd("ColorScheme", {
    pattern = "darcula-dark",
    callback = function()
        -- Enhance certain highlight groups for better readability
        vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3A3A3A" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3A3A3A" })
        vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#606366", bg = "NONE" })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#606366" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#A9B7C6", bold = true })
    end,
})

-- Set better diff colors for Darcula
autocmd("VimEnter", {
    callback = function()
        if vim.g.colors_name == "darcula-dark" then
            vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#294436" })
            vim.api.nvim_set_hl(0, "DiffChange", { bg = "#385570" })
            vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#484A4A" })
            vim.api.nvim_set_hl(0, "DiffText", { bg = "#4C5762" })
        end
    end,
})
