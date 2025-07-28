return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        cmd = { "SupermavenUseFree", "SupermavenStatus" },
        config = function()
            require("supermaven-nvim").setup({})
        end,
    },
}
