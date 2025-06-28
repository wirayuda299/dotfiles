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
        event = "VeryLazy",
        config = function()
            require("tabzen").setup({
                keymaps = {
                    close_tab = "<leader>x",
                }
            })
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
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
        event = "VeryLazy",
        config = function()
            require("indentmini").setup({
                char = "│",
                exclude = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            })

            -- Brighter indent line for darcula-dark theme
            vim.cmd('highlight IndentLine guifg=#5a5a5a') -- Good balance for darcula
            -- Alternative options for darcula-dark:
            -- vim.cmd('highlight IndentLine guifg=#6a6a6a')  -- Brighter
            -- vim.cmd('highlight IndentLine guifg=#808080')  -- Even more visible
            -- vim.cmd('highlight IndentLine guifg=#4f5b66')  -- Slightly blue-tinted (matches darcula's UI)
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
            vim.cmd.colorscheme("darcula-dark")
        end
    }
}
