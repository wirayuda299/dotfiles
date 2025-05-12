return {
  "rest-nvim/rest.nvim",
  cmd = { "Rest" },
  ft = { "http" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
}
