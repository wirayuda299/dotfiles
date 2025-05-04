return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	lazy = true,
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({})
	end,
	build = ':lua require("go.install").update_all_sync()',
}
