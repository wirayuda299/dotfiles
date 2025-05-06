return {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("onedarkpro").setup({
            plugins = {
                nvim_tree = false,
                indentline = true
            },
        })
        vim.cmd("colorscheme onedark_dark")
    end,
}
