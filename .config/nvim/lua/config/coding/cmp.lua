local cmp = require("cmp")
local luasnip = require("luasnip")

local function get_theme_colors()
    local colors = {}

    local function get_hl_color(group, attr)
        local hl = vim.api.nvim_get_hl(0, { name = group })
        if hl[attr] then
            return string.format("#%06x", hl[attr])
        end
        return nil
    end

    colors.bg = get_hl_color("Normal", "bg") or "#1e1e2e"
    colors.fg = get_hl_color("Normal", "fg") or "#cdd6f4"
    colors.bg_alt = get_hl_color("NormalFloat", "bg") or get_hl_color("Pmenu", "bg") or colors.bg
    colors.fg_alt = get_hl_color("NormalFloat", "fg") or get_hl_color("Pmenu", "fg") or colors.fg
    colors.selection_bg = get_hl_color("PmenuSel", "bg") or get_hl_color("Visual", "bg") or "#313244"
    colors.selection_fg = get_hl_color("PmenuSel", "fg") or colors.fg
    colors.border = get_hl_color("FloatBorder", "fg") or get_hl_color("WinSeparator", "fg") or "#6c7086"
    colors.comment = get_hl_color("Comment", "fg") or "#6c7086"
    colors.function_color = get_hl_color("Function", "fg") or "#89b4fa"
    colors.keyword_color = get_hl_color("Keyword", "fg") or "#cba6f7"
    colors.string_color = get_hl_color("String", "fg") or "#a6e3a1"
    colors.number_color = get_hl_color("Number", "fg") or "#fab387"
    colors.type_color = get_hl_color("Type", "fg") or "#f9e2af"
    colors.variable_color = get_hl_color("Identifier", "fg") or "#f38ba8"
    colors.constant_color = get_hl_color("Constant", "fg") or "#eba0ac"

    return colors
end

local function detect_theme_style()
    -- Check if FloatBorder exists and has specific styling
    local float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
    local winbar = vim.api.nvim_get_hl(0, { name = "WinBar" })
    local diagnostic_info = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })

    local has_rich_borders = float_border.fg ~= nil
    local has_rich_diagnostics = diagnostic_info.fg ~= nil
    local has_modern_features = winbar.fg ~= nil or winbar.bg ~= nil

    -- Check color complexity (modern themes often have more nuanced colors)
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local pmenu_bg = vim.api.nvim_get_hl(0, { name = "Pmenu" }).bg
    local has_bg_variations = normal_bg ~= nil and pmenu_bg ~= nil and normal_bg ~= pmenu_bg

    -- Calculate a "modernity score"
    local modernity_score = 0
    if has_rich_borders then modernity_score = modernity_score + 1 end
    if has_rich_diagnostics then modernity_score = modernity_score + 1 end
    if has_modern_features then modernity_score = modernity_score + 1 end
    if has_bg_variations then modernity_score = modernity_score + 1 end

    -- Check if theme supports transparency
    local supports_transparency = normal_bg == nil

    return {
        is_modern = modernity_score >= 2,
        supports_transparency = supports_transparency,
        has_rich_colors = has_rich_diagnostics and has_rich_borders,
    }
end

local function get_border_style()
    local style = detect_theme_style()

    if style.is_modern and style.has_rich_colors then
        return { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    elseif style.supports_transparency then
        return "none"
    else
        return "rounded"
    end
end

local function setup_highlights()
    local colors = get_theme_colors()
    local style = detect_theme_style()

    local function adjust_color_intensity(color, factor)
        if not color or not color:match("^#%x%x%x%x%x%x$") then
            return color
        end

        local r = tonumber(color:sub(2, 3), 16)
        local g = tonumber(color:sub(4, 5), 16)
        local b = tonumber(color:sub(6, 7), 16)

        r = math.floor(math.min(255, r * factor))
        g = math.floor(math.min(255, g * factor))
        b = math.floor(math.min(255, b * factor))

        return string.format("#%02x%02x%02x", r, g, b)
    end

    vim.api.nvim_set_hl(0, "CmpPmenu", {
        bg = colors.bg_alt,
        fg = colors.fg_alt
    })

    local selection_intensity = style.is_modern and 1.1 or 1.0
    vim.api.nvim_set_hl(0, "CmpSel", {
        bg = adjust_color_intensity(colors.selection_bg, selection_intensity),
        fg = colors.selection_fg,
        bold = style.has_rich_colors
    })

    vim.api.nvim_set_hl(0, "CmpBorder", {
        fg = colors.border
    })

    vim.api.nvim_set_hl(0, "CmpDoc", {
        bg = colors.bg_alt,
        fg = colors.fg_alt
    })

    vim.api.nvim_set_hl(0, "CmpDocBorder", {
        fg = colors.border
    })

    -- Ghost text - more subtle for modern themes
    local ghost_intensity = style.is_modern and 0.7 or 0.8
    vim.api.nvim_set_hl(0, "CmpGhostText", {
        fg = adjust_color_intensity(colors.comment, ghost_intensity),
        italic = true
    })

    local kind_colors = {
        CmpItemKindVariable = { fg = colors.variable_color },
        CmpItemKindFunction = { fg = colors.function_color },
        CmpItemKindMethod = { fg = colors.function_color },
        CmpItemKindKeyword = { fg = colors.keyword_color },
        CmpItemKindProperty = { fg = colors.type_color },
        CmpItemKindField = { fg = colors.type_color },
        CmpItemKindUnit = { fg = colors.number_color },
        CmpItemKindValue = { fg = colors.number_color },
        CmpItemKindConstant = { fg = colors.constant_color },
        CmpItemKindEnum = { fg = colors.type_color },
        CmpItemKindEnumMember = { fg = colors.constant_color },
        CmpItemKindStruct = { fg = colors.type_color },
        CmpItemKindClass = { fg = colors.type_color },
        CmpItemKindInterface = { fg = colors.type_color },
        CmpItemKindText = { fg = colors.string_color },
        CmpItemKindSnippet = { fg = colors.keyword_color },
        CmpItemKindFile = { fg = colors.fg },
        CmpItemKindFolder = { fg = colors.fg },
        CmpItemKindModule = { fg = colors.type_color },
    }

    for name, opts in pairs(kind_colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end


local cmp_select = { behavior = cmp.SelectBehavior.Select }

local options = {
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 1,
    },

    window = {
        completion = {
            border = "",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
            scrollbar = false,
            col_offset = -3,
            side_padding = 0,
            max_width = 80,
            max_height = 12,
        },
        documentation = {
            border = get_border_style(),
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
            max_width = 80,
            max_height = 12,
        },
    },


    formatting = {
        format = function(entry, vim_item)
            local source_icons = {
                nvim_lsp = "λ",
                luasnip = "",
                nvim_lua = "",
                path = "",
            }

            local source_highlights = {
                nvim_lsp = "CmpItemKindFunction",
                luasnip = "CmpItemKindSnippet",
                nvim_lua = "CmpItemKindLua",
                path = "CmpItemKindFolder",
            }

            vim_item.menu = source_icons[entry.source.name] or ""
            vim_item.menu_hl_group = source_highlights[entry.source.name]
            return vim_item
        end,
    },


    experimental = {
        ghost_text = {
            hl_group = "CmpGhostText",
        },
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<Down>"] = cmp.mapping.select_next_item(cmp_select),
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
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
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

    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
            priority = 1000,
            max_item_count = 10,
            entry_filter = function(entry)
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
            end
        },
        { name = "luasnip",  priority = 900, max_item_count = 10 },
        { name = "path",     priority = 800, max_item_count = 10 },
        { name = "nvim_lua", priority = 700, max_item_count = 10 },
    }),

    performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 200,
    },

    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset, cmp.config.compare.exact,
            cmp.config.compare.score, cmp.config.compare.recently_used,
            cmp.config.compare.locality, cmp.config.compare.kind,
            cmp.config.compare.sort_text, cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
}

setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.schedule(setup_highlights)
    end,
})

return options
