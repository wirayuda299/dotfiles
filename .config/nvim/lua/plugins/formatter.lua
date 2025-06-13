return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = function()
    return require "configs.conform"
  end,
}
