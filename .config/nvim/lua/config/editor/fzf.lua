-- Cache fd_opts to avoid string concatenation on every load
local fd_opts =
"--color=never --type f --type l --hidden --follow --exclude .git --exclude node_modules --exclude dist --exclude build --exclude .next --exclude .nuxt --exclude .turbo --exclude .expo --exclude .idea --exclude .vscode --exclude .DS_Store --exclude .cache --exclude target --exclude vendor --exclude coverage --exclude out --exclude public --exclude tmp --exclude logs --exclude yarn.lock --exclude package-lock.json --exclude pnpm-lock.yaml"

local options = {
    -- Global FZF options for modern look
    fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline-right",
        ["--height"] = "100%",
        ["--multi"] = true,
        ["--ansi"] = true,
        ["--prompt"] = "❯ ",
        ["--pointer"] = "▶",
        ["--marker"] = "✓",
        ["--color"] =
        "bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796",
    },

    -- Beautiful previewers without treesitter
    previewers = {
        builtin = {
            syntax = false,
            syntax_limit_b = 1024 * 100, -- 100KB
            limit_b = 1024 * 1024 * 2,   -- 2MB
            extensions = {
                ["png"] = { "chafa", "{file}" },
                ["jpg"] = { "chafa", "{file}" },
                ["jpeg"] = { "chafa", "{file}" },
                ["gif"] = { "chafa", "{file}" },
                ["webp"] = { "chafa", "{file}" },
            },
        },
        bat = {
            cmd = "bat",
            args = "--color=always --style=header,grid,numbers --line-range=:500",
        },
        head = {
            cmd = "head",
            args = "-n 50",
        },
    },

    -- Modern window options with single border and smaller preview
    winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.5,
        col = 0.5,
        border = "rounded",
        backdrop = 60,
        preview = {
            default = "bat",
            delay = 10,
            layout = "flex",
            flip_columns = 120,
            horizontal = "right:35%", -- Smaller preview (was 55%)
            vertical = "down:45%",    -- Smaller preview (was 60%)
            wrap = "nowrap",
            title = true,
            title_pos = "center",
            scrollbar = "float",
            scrolloff = "-2",
            winopts = {
                number = false,
                relativenumber = false,
                cursorline = true,
                cursorlineopt = "both",
                cursorcolumn = false,
                signcolumn = "no",
                list = false,
                foldenable = false,
                wrap = false,
            },
        },
    },

    -- Enhanced file options
    files = {
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules'",
        fd_opts = fd_opts,
        cwd_prompt = false,
        actions = {
            ["alt-i"] = { "toggle-ignore" },
            ["alt-h"] = { "toggle-hidden" },
        },
    },

    -- Enhanced grep with better colors
    grep = {
        rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --hidden --follow -g '!.git' -g '!node_modules'",
        input_prompt = "Grep❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        actions = {
            ["ctrl-g"] = { "grep_lgrep" },
        },
    },

    -- Git integration
    git = {
        files = {
            cmd = "git ls-files --exclude-standard",
            multiprocess = true,
        },
        status = {
            cmd = "git -c color.status=false status --short --untracked-files=all",
            preview = "git diff --color=always {-1}",
            actions = {
                ["right"] = { "stage-unstage" },
                ["left"] = { "stage-unstage" },
            },
        },
        commits = {
            cmd =
            "git log --color=always --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s' --date=short",
            preview = "git show --color=always {1}",
        },
        bcommits = {
            cmd =
            "git log --color=always --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s' --date=short",
            preview = "git show --color=always {1} -- {file}",
        },
    },

    -- Enhanced keymaps
    keymap = {
        builtin = {
            true,
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<C-/>"] = "toggle-preview",
            ["<A-j>"] = "preview-down",
            ["<A-k>"] = "preview-up",
        },
        fzf = {
            true,
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-a"] = "toggle-all",
            ["ctrl-/"] = "toggle-preview",
        },
    },
}

return options
