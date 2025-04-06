return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    "dist",
                    "build",
                    "public",
                    "static",
                    "*.log",
                    "*.tmp",
                    "*.temp",
                    "*.lock",
                    "*.lockb",
                    "*.lockb.tmp",
                    "*.lockb.temp",
                    "*.lockb.lock",
                    "*.lockb.lockb",
                    "*.lockb.lockb.tmp",
                    ".git",
                    ".gitignore",
                    ".gitignore.tmp",
                    ".gitignore.temp",
                    ".gitignore.lock",
                    ".gitignore.lockb",
                    ".gitignore.lockb.tmp",
                    ".gitignore.lockb.lock",
                    ".gitignore.lockb.lockb",
                    ".gitignore.lockb.lockb.tmp",
                    ".gitignore.lockb.lockb.lock",
                    ".gitignore.lockb.lockb.lockb",
                    ".gitignore.lockb.lockb.lockb.tmp",
                    ".next",
                    ".nextignore",
                    ".nextignore.tmp",
                    ".nextignore.temp",
                    ".nextignore.lock",
                    ".nextignore.lockb",
                    ".nextignore.lockb.tmp",
                },

                file_previewer = require('telescope.previewers').vim_buffer_cat.new,
                grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
                qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,


            },

            pickers = {
                find_files = {
                    hidden = true,
                },

            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<C-g>', builtin.git_files, {})
        vim.keymap.set('n', '<C-f>', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>gr', function()
            builtin.help_tags({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers'})
        vim.keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = 'Workspace Diagnostics'})
        --quickfix list
        vim.keymap.set('n', '<leader>q', '<cmd>Telescope quickfix<cr>', { desc = 'Quickfix List'})
        
    end
}