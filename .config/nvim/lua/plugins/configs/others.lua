local M = {}

M.setup = function()
	local luasnip = require("luasnip")
	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	require("luasnip.loaders.from_vscode").lazy_load()
	if vim.g.vscode_snippets_path then
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = vim.g.vscode_snippets_path,
		})
	end

	require("luasnip.loaders.from_snipmate").lazy_load()
	if vim.g.snipmate_snippets_path then
		require("luasnip.loaders.from_snipmate").lazy_load({
			paths = vim.g.snipmate_snippets_path,
		})
	end

	require("luasnip.loaders.from_lua").lazy_load()
	if vim.g.lua_snippets_path then
		require("luasnip.loaders.from_lua").lazy_load({
			paths = vim.g.lua_snippets_path,
		})
	end

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			local session = require("luasnip").session
			if session.current_nodes[vim.api.nvim_get_current_buf()] and not session.jump_active then
				require("luasnip").unlink_current()
			end
		end,
	})
end

return M
