local toggle = require "configs.pde"
return {
  { "nvim-treesitter/nvim-treesitter", enabled = toggle.treesitter },
  { "lewis6991/gitsigns.nvim", enabled = toggle.gitsigns },
  { "lukas-reineke/indent-blankline.nvim", enabled = toggle.indent_blankline },
  { "folke/which-key.nvim", enabled = toggle.which_key },
  { "nvim-telescope/telescope.nvim", enabled = toggle.telescope },
  { "nvzone/volt", enabled = toggle.volt },
  { "nvzone/minty", enabled = toggle.minty },
  { "ray-x/cmp-treesitter", enabled = toggle.cmp_treesitter },
  { "akinsho/bufferline.nvim", enabled = toggle.bufferline },
  {
    "azratul/expose-localhost.nvim",
    lazy = true,
    enabled = toggle.exposed,
    event = "VeryLazy",
    cmd = { "ExposeStart" },
    ft = { "html", "javascript", "typescript", "svelte", "astro" },
  },
  {
    "Wansmer/symbol-usage.nvim",
    enabled = toggle.symbol_usage,
    event = "LspAttach",
    opts = {
      vt_position = "end_of_line",
      text_format = function(symbol)
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          return string.format(" 󰌹 %s %s", num, usage)
        else
          return ""
        end
      end,
    },
  },
}
