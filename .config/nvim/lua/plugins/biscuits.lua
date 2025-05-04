-- give hint on block code
return {
	"code-biscuits/nvim-biscuits",
	event = "BufReadPost",
	on_events = { "InsertLeave", "CursorHoldI" },
	opts = {
		show_on_start = true,
		cursor_line_only = true,
		default_config = {
			min_distance = 5,
			max_length = 80,
			prefix_string = " ✨ ",
			prefix_highlight = "Comment",
			enable_linehl = true,
		},
	},
	keys = {
		{
			"<leader>bb",
			function()
				require("nvim-biscuits").BufferAttach()
			end,
			mode = "n",
			desc = "Enable Biscuits",
		},
	},
	config = function()
		require("nvim-biscuits").setup({
			cursor_line_only = true,
		})
	end,
}
