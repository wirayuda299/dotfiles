local cmp = require("cmp")
local luasnip = require("luasnip")

local cache = {
    colors = nil,
    highlights_applied = false,
    last_colorscheme = nil,
    debounce_timer = nil,
}

local function get_optimized_colors()
    local current_colorscheme = vim.g.colors_name or "default"

    if cache.colors and cache.last_colorscheme == current_colorscheme then
        return cache.colors
    end

    -- Single batch call for all highlights
    local highlights = vim.api.nvim_get_hl(0, {})

    local function extract_color(hl_name, attr, fallback)
        local hl = highlights[hl_name]
        if hl and hl[attr] then
            return string.format("#%06x", hl[attr])
        end
        return fallback
    end

    cache.colors = {
        bg = extract_color("Normal", "bg", "#1e1e2e"),
        fg = extract_color("Normal", "fg", "#cdd6f4"),
        bg_alt = extract_color("Pmenu", "bg", "#313244"),
        fg_alt = extract_color("Pmenu", "fg", "#cdd6f4"),
        selection_bg = extract_color("PmenuSel", "bg", "#585b70"),
        selection_fg = extract_color("PmenuSel", "fg", "#cdd6f4"),
        border = extract_color("FloatBorder", "fg", "#6c7086"),
        comment = extract_color("Comment", "fg", "#6c7086"),

        -- Semantic colors with smart fallbacks
        blue = extract_color("Function", "fg", "#89b4fa"),
        green = extract_color("String", "fg", "#a6e3a1"),
        yellow = extract_color("Type", "fg", "#f9e2af"),
        red = extract_color("Error", "fg", "#f38ba8"),
        purple = extract_color("Keyword", "fg", "#cba6f7"),
        orange = extract_color("Number", "fg", "#fab387"),
    }

    cache.last_colorscheme = current_colorscheme
    return cache.colors
end

-- Efficient highlight setup with reduced API calls
local function setup_modern_highlights()
    if cache.highlights_applied and cache.last_colorscheme == (vim.g.colors_name or "default") then
        return
    end

    local colors = get_optimized_colors()

    -- Modern glassmorphism-inspired highlights
    local highlights = {
        -- Main completion window with subtle transparency effect
        CmpPmenu = {
            bg = colors.bg_alt,
            fg = colors.fg_alt,
            blend = 10 -- Subtle transparency for modern look
        },

        -- Selection with modern accent
        CmpSel = {
            bg = colors.selection_bg,
            fg = colors.selection_fg,
            bold = true,
            italic = false -- Avoid italic for performance
        },

        -- Modern borders
        CmpBorder = { fg = colors.border, bg = "NONE" },

        -- Documentation window
        CmpDoc = { bg = colors.bg_alt, fg = colors.fg_alt, blend = 5 },
        CmpDocBorder = { fg = colors.border, bg = "NONE" },

        -- Ghost text for snippets
        CmpGhostText = { fg = colors.comment, italic = true },

        -- Kind icons with semantic colors
        CmpItemKindFunction = { fg = colors.blue, bg = "NONE" },
        CmpItemKindMethod = { fg = colors.blue, bg = "NONE" },
        CmpItemKindVariable = { fg = colors.fg, bg = "NONE" },
        CmpItemKindKeyword = { fg = colors.purple, bg = "NONE" },
        CmpItemKindSnippet = { fg = colors.green, bg = "NONE" },
        CmpItemKindText = { fg = colors.fg_alt, bg = "NONE" },
        CmpItemKindClass = { fg = colors.yellow, bg = "NONE" },
        CmpItemKindInterface = { fg = colors.yellow, bg = "NONE" },
        CmpItemKindModule = { fg = colors.orange, bg = "NONE" },
        CmpItemKindProperty = { fg = colors.red, bg = "NONE" },
        CmpItemKindFile = { fg = colors.fg_alt, bg = "NONE" },
        CmpItemKindFolder = { fg = colors.yellow, bg = "NONE" },

        -- Match highlighting
        CmpItemAbbrMatch = { fg = colors.blue, bold = true, bg = "NONE" },
        CmpItemAbbrMatchFuzzy = { fg = colors.blue, bg = "NONE" },

        -- Deprecated items
        CmpItemAbbrDeprecated = { fg = colors.comment, strikethrough = true, bg = "NONE" },
    }

    -- Batch apply highlights for performance
    for name, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, opts)
    end

    cache.highlights_applied = true
end

-- Performance-optimized debounced highlight refresh
local function refresh_highlights()
    if cache.debounce_timer then
        cache.debounce_timer:stop()
        cache.debounce_timer:close()
    end

    cache.debounce_timer = vim.defer_fn(function()
        cache.colors = nil
        cache.highlights_applied = false
        cache.last_colorscheme = nil
        setup_modern_highlights()
    end, 100) -- 100ms debounce for smooth colorscheme changes
end

-- Modern formatting with icons
local function format_completion(entry, vim_item)
    -- Modern icons with Unicode fallbacks
    local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
    }

    -- Source indicators
    local source_icons = {
        nvim_lsp = "󰒋",
        luasnip = "",
        buffer = "󰈚",
        path = "󰉋",
        nvim_lua = "",
    }

    -- Set icon
    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "󰠱", vim_item.kind)

    -- Set source with clean formatting
    local source_name = entry.source.name
    vim_item.menu = string.format("  %s", source_icons[source_name] or "")

    -- Truncate long completions for performance
    if #vim_item.abbr > 25 then
        vim_item.abbr = vim_item.abbr:sub(1, 22) .. "…"
    end

    return vim_item
end

-- Optimized configuration
local options = {
    -- Performance settings optimized for low-spec devices
    performance = {
        debounce = 60,          -- Slightly higher debounce for lower CPU usage
        throttle = 30,          -- Reduced throttle for responsiveness
        fetching_timeout = 200, -- Faster timeout
        confirm_resolve_timeout = 80,
        async_budget = 1,       -- Lower async budget for weak devices
        max_view_entries = 30,  -- Fewer entries to reduce memory usage
    },

    completion = {
        completeopt = "menu,menuone,noselect", -- noselect for better UX
        keyword_length = 2,                    -- Require 2 chars to reduce noise
    },

    -- Modern window styling
    window = {
        completion = {
            border = "",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
            scrollbar = false, -- Disable scrollbar for performance
            col_offset = -3,
            side_padding = 1,
            max_width = 60, -- Smaller for low-spec devices
            max_height = 10,
        },
        documentation = {
            border = "",
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
            max_width = 60,
            max_height = 10,
        },
    },

    formatting = {
        format = format_completion,
        fields = { "kind", "abbr", "menu" }, -- Optimized field order
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    -- Optimized key mappings
    mapping = cmp.mapping.preset.insert({
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    -- Optimized sources with priority and limits
    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
            priority = 1000,
            max_item_count = 15, -- Reduced for performance
            entry_filter = function(entry)
                -- Filter out text completions from LSP for performance
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
            end,
        },
        {
            name = "luasnip",
            priority = 900,
            max_item_count = 8,
        },
        {
            name = "path",
            priority = 700,
            max_item_count = 8,
            trigger_characters = { "/" },
        },
        {
            name = "nvim_lua",
            priority = 600,
            max_item_count = 8,
        },
    }),

    -- Optimized sorting for performance
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
}

-- Initialize highlights
setup_modern_highlights()

-- Efficient autocmd for colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = refresh_highlights,
    desc = "Refresh completion highlights on colorscheme change"
})

-- Optional: Add a command to manually refresh highlights
vim.api.nvim_create_user_command("CmpRefreshHighlights", function()
    refresh_highlights()
    print("Completion highlights refreshed!")
end, { desc = "Manually refresh completion highlights" })

return options
