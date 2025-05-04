return {
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"gopls",
					"clangd",
					"tailwindcss",
					"svelte",
					"astro",
					"cssls",
					"dockerls",
					"html",
					"jsonls",
					"rust_analyzer",
					"sqls",
				},
				automatic_installation = true,
			})

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					go = { "gofmt" },
					svelte = { "prettier" },
					astro = { "prettier" },
					sqls = { "sqlfmt" },
				},
				format_after_save = {
					timeout_ms = 3000,
					async = true,
					lsp_fallback = true,
				},
			})

			require("plugins.configs.lspconfig").setup()
			vim.diagnostic.config({
				virtual_text = {
					prefix = "•",
				},
				severity_sort = true,
				signs = false,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "•",
					spacing = 4,
				},
			})
		end,
	},
}
