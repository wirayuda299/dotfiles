return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			no_italic = false,
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = false,
					indentscope_color = "",
				},
			},
		})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
