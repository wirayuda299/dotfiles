return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      max_width = 0.5,
      max_height = 0.5,
    }

  },
  cmd = { "Oil" }
}
