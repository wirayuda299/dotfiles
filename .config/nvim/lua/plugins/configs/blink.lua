return {
  appearance = {
    nerd_font_variant = "mono",
    kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "󰛡",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "󰜰",
      Module = "󰏗",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "󰒻",
      Keyword = "󰌋",
      Snippet = "󰅴",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "󰒻",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "󱐋",
      Operator = "󰆕",
      TypeParameter = "󰊄",
    }
  },
  fuzzy = { implementation = "prefer_rust" },
  sources = {
    default = {
      "lsp", "snippets", "path",
    },
    providers = {
      lsp = {
        score_offset = 1000,
        async = true,
      },
      snippets = { score_offset = 500 },
      path = {
        score_offset = 100,
        opts = {
          get_cwd = function(_)
            return vim.fn.getcwd()
          end,
        },
      },
    }
  },

  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<Down>"] = { "select_next", "snippet_forward", "fallback" },
    ["<Up>"] = { "select_prev", "snippet_backward", "fallback" },
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },

  completion = {
    ghost_text = { enabled = false },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 150,
      window = {
        border = "rounded",
        winblend = 10,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
        max_width = 80,
        max_height = 20,
      },
    },
    --
    -- list = {
    --   max_items = function(ctx)
    --     -- Get the source name
    --     local source = ctx.source
    --     if source == 'lsp' then
    --       local clients = vim.lsp.get_clients({ bufnr = 0 })
    --       for _, client in ipairs(clients) do
    --         if client.name == 'tailwindcss' then
    --           return 8
    --         end
    --       end
    --     end
    --     return 200
    --   end,
    -- },
    -- --
    menu = {
      border = "none",
      scrollbar = false,
    }
  },

}
