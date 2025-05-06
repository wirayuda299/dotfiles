return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {},
	config = function()
		require("noice").setup({
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
	end,
}
