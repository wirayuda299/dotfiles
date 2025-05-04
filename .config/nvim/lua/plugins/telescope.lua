return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- wajib
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	cmd = "Telescope",
	opts = function()
		return require("plugins.configs.telescope")
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
	end,
}
