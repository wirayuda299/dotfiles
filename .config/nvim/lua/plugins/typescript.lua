return {
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    lazy = true,
    event = { "VeryLazy" },
    opts = {},
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
    ft = { "typescript", "typescriptreact" },
    opts = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    config = function(_, opts)
      require("typescript-tools").setup(opts)
    end,
  },

}
