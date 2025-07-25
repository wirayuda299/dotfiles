return {
  defaults = { lazy = true, version = false, },
  install = { colorscheme = { "default" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    cache = { enabled = true },
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor", "zipPlugin", "rplugin", "editorconfig",
        "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "syntax", "nvim-treesitter",
        "2html_plugin", "getscript", "getscriptPlugin", "logipat", "tar", "rrhelper", "netrw",
        "netrwplugin", "spellfile_plugin", "vimball", "vimballPlugin", "zip", "netrw", "netrwPlugin", "osc52", "shada",
        "spellfile", "man", "filetype", "shada", "spellfile", "vimball", "zipPlugin" }
    },
  },
}
