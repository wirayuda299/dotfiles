return {

    {
        "VidocqH/lsp-lens.nvim",
        event = "LspAttach",
        config = function()
            require("lsp-lens").setup({})
        end,
    },

    -- {
    --     "ivanjermakov/troublesum.nvim",
    --     event = "LspAttach",
    --     config = function()
    --         require("troublesum").setup()
    --     end,
    -- },
    {
        "dmmulroy/ts-error-translator.nvim",
        ft = "javascript,typescript,typescriptreact,svelte,astro",
        config = function()
            require("ts-error-translator").setup()
        end
    },
}
