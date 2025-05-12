return {
  "ibhagwan/fzf-lua",
  opts = {
    previewers = {
      builtin = {
        syntax = false,
        syntax_limit_b = 1024 * 100, -- 100KB
      },
      treesitter = {
        enabled = false,
      },
    },
    winopts = {
      height = 0.5,
      width = 0.85,
      row = 0.3,
      col = 0.5,
      border = "rounded",
      fullscreen = false,
      preview = {
        delay = 50,
        layout = "horizontal", -- biar preview di kanan
        horizontal = "right:50%", -- preview 50% di kanan
        wrap = "wrap",
        title = true,
        filesize_limit = 1024 * 1000, -- 1MB
      },
    },
    fzf_opts = {
      ["--ansi"] = "",
      ["--prompt"] = "🔍 ",
      ["--bind"] = "toggle-preview:alt-p",
      ["--color"] = "prompt:italic:underline,bg+:24,gutter:-1",
    },
  },
}
