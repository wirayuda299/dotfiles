return {

    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = true, -- Auto close on trailing </
        },
        config = function(_, opts)
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-ts-autotag").setup({
                opts,
            })
        end,
    },
}
