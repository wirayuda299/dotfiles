local options = {
    signs = {
        add          = { text = '┃' }, -- Thick vertical line for additions
        change       = { text = '┃' }, -- Thick vertical line for changes
        delete       = { text = '━' }, -- Horizontal line for deletions
        topdelete    = { text = '━' }, -- Horizontal line for top deletions
        changedelete = { text = '╋' }, -- Cross for change+delete
        untracked    = { text = '┋' }, -- Dotted line for untracked
    },

    -- Enhanced sign highlighting
    signcolumn = true,
    numhl = false,  -- Don't highlight line numbers
    linehl = false, -- Don't highlight entire lines
    word_diff = false,

    -- Modern blame line with better styling
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- End of line
        delay = 200,           -- Faster response
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter = function(name, blame_info, opts)
        if blame_info.author == name then
            blame_info.author = "You"
        end

        local text
        if blame_info.author == 'Not Committed Yet' or blame_info.author == 'You' then
            text = blame_info.author
        else
            local date = require('gitsigns.util').get_relative_time(tonumber(blame_info['author_time']))
            text = string.format('%s • %s', blame_info.author, date)
        end

        return { { '  ' .. text, 'GitSignsCurrentLineBlame' } }
    end,

    -- Enhanced preview and navigation
    preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },

    -- Smooth updates
    update_debounce = 50,
    max_file_length = 40000,

    -- Better attachment behavior
    attach_to_untracked = true,

    -- Enhanced trouble integration
    trouble = true,

    -- Modern keymaps with better UX
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation with preview
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = "Next hunk" })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = "Prev hunk" })

        -- Actions with better descriptions
        map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Stage selected" })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Reset selected" })
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame line" })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle blame" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
        map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object for hunks
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
    end,

    -- Enhanced watch settings
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },

    -- Better sign priority
    sign_priority = 6,

    -- Status line integration
    status_formatter = function(status)
        local added, changed, removed = status.added, status.changed, status.removed
        local status_txt = {}
        if added and added > 0 then table.insert(status_txt, '+' .. added) end
        if changed and changed > 0 then table.insert(status_txt, '~' .. changed) end
        if removed and removed > 0 then table.insert(status_txt, '-' .. removed) end
        return table.concat(status_txt, ' ')
    end,
}

return options
