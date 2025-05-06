local cmp = require("cmp")

local duplicates = {
	buffer = 1,
	path = 1,
	nvim_lsp = 0,
	luasnip = 1,
}

local source_names = {
	nvim_lsp = "(LSP)",
	luasnip = "(Snippet)",
	buffer = "(Buffer)",
	path = "(Path)",
}

local compare = require("cmp.config.compare")
local options = {
	completion = {
		autocomplete = false,
		completeopt = "menu,menuone,noselect",
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			compare.score,
			compare.recently_used,
			compare.offset,
			compare.exact,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		},
	},

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, item)
			local duplicates_default = 0
			item.menu = source_names[entry.source.name]
			item.dup = duplicates[entry.source.name] or duplicates_default
			return item
		end,
	},
	sources = {
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "luasnip", group_index = 2 },
		{ name = "buffer", group_index = 2 },
		{ name = "async_path", group_index = 2 },
		{ name = "nvim_lua", ft = "lua", group_index = 2 },
	},
}

return options
