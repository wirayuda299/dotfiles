return {

	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

	config = function()
		local config = require("plugins.configs.treesitter")
		require("nvim-treesitter.configs").setup(config)
	end,
}
