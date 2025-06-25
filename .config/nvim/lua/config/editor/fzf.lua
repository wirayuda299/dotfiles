local options = {
    fzf_opts = {
        ["--layout"] = "reverse-list",
        ["--info"] = "inline-right",
        ["--height"] = "100%",
        ["--multi"] = true,
    },
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
            layout = "horizontal",    -- biar preview di kanan
            horizontal = "right:50%", -- preview 50% di kanan
            wrap = "wrap",
            title = true,
            filesize_limit = 1024 * 1000, -- 1MB
        },
    },
    files = {
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git'",
    },
    grep = {
        rg_opts = "--hidden --follow --smart-case --column --line-number --no-heading --color=always",
    },
}
return options
