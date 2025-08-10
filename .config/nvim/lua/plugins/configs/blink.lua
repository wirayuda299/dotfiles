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
    default = { "lsp", "snippets", "path" },
    providers = {
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      lsp = {
        score_offset = 1000,
        async = true,
        transform_items = function(_, items)
          if vim.bo.filetype == "xml" and vim.fn.expand("%:e") == "fxml" then
            return vim.tbl_filter(function(item)
              return true
            end, items)
          end
          return items
        end,
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
  signature = { enabled = true },

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
    list = {
      selection = {
        preselect = false,
        auto_insert = false
      },
    },
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
    menu = {
      border = "none",
      scrollbar = false,
    }
  },

}
