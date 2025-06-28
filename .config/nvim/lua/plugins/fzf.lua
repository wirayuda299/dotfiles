return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader><space>", "<cmd>FzfLua files<cr>",       desc = "find files" },
        { "<leader>,",       "<cmd>FzfLua buffers<cr>",     desc = "switch buffer" },
        { "<leader>fw",      "<cmd>FzfLua live_grep<cr>",   desc = "grep" },
        { "<leader>gc",      "<cmd>FzfLua git_commits<cr>", desc = "commits" },
        { "<leader>gs",      "<cmd>FzfLua git_status<cr>",  desc = "status" },
        { "<leader>km",      "<cmd>FzfLua keymaps<cr>",     desc = "keymaps" }
    },
    opts = function()
        return require("config.editor.fzf")
    end,

}
