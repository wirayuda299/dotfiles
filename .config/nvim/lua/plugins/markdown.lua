-- plugin file for render-markdown.

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = require "configs.render-markdown",
  cmd = { "RenderMarkdown" },
}

-- End of file.
