return {
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--info"] = "inline-right",
    ["--height"] = "100%",
    ["--multi"] = true,
    ["--ansi"] = true,
    ["--prompt"] = "❯ ",
    ["--pointer"] = "▶",
    ["--marker"] = "✓",
  },
  previewers = {
    builtin = {
      syntax = false,
      treesitter = { enabled = false }
    },
  },
  winopts = {
    height = 0.50,
    width = 0.50,
    row = 0.5,
    col = 0.5,
    border = "rounded",
    backdrop = 60,
    preview = {
      hidden = "hidden",
    },
  },

  files = {
    cmd =
    "rg --files --hidden --glob '!.git' --glob '!node_modules' --glob '!tmp' --glob '!dist' --glob '!build' --glob '!.next' --glob '!coverage' --glob '!out' --glob '!target'",
    cwd_prompt = false,
  },

  grep = {
    rg_opts =
    "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git' --glob '!node_modules' --glob '!dist' --glob '!build'",
    input_prompt = "Grep❯ ",
    multiprocess = true,
    git_icons = false,
    file_icons = false,
    color_icons = false,
  },
}
