return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = function()
    return require "configs.blink"
  end,
}
