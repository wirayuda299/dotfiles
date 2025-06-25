return {
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        keys = {
            { "<C-n>",     "<cmd>NvimTreeToggle<CR>", desc = "Toggle explorer" },
            { "<leader>e", "<cmd>NvimTreeFocus<CR>",  desc = "NvimTreeFocus" },
        },
        opts = function()
            return require("config.editor.nvimtree")
        end,
    },

    {
        "wirayuda09/tabzen",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("tabzen").setup({
                max_tab_width = 25,
                show_tab_numbers = true,
                keymaps = {
                    next_tab = "<Tab>",
                    prev_tab = "<S-Tab>",
                    close_tab = "<leader>x",
                }
            })
        end
    },


    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            return require("config.ui.git")
        end
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = function()
            return require("config.ui.autopairs")
        end
    },

    {
        "nvimdev/indentmini.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("indentmini").setup()
        end,
    },
    {
        "wirayuda09/statusline",
        event = "VeryLazy",
        config = function()
            vim.schedule(function()
                require('statusline').setup()
            end)
        end
    },

    {
        "xiantang/darcula-dark.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.schedule(function()
                vim.cmd.colorscheme("darcula-dark")
            end)
        end
    }
}
