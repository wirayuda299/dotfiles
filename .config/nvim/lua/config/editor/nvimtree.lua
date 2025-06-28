local options = {
    disable_netrw = true,
    hijack_netrw = true,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,

    view = {
        width = 30, -- WebStorm-like width
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "no",            -- Clean WebStorm look
        centralize_selection = false, -- WebStorm doesn't auto-center
        adaptive_size = false,
        float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "editor",
                border = "none", -- WebStorm has no borders
                row = 1,
                col = 1,
            },
        },
    },

    renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "name",
        highlight_modified = "name",
        -- Clean root folder display without emoji icons
        root_folder_label = function(path)
            return vim.fn.fnamemodify(path, ":~") .. "/"
        end,
        indent_width = 2,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "├",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            modified_placement = "after",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                modified = "●",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
        symlink_destination = true,
    },

    hijack_directories = {
        enable = true,
        auto_open = true,
    },

    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
        -- Add this to expand folders to show current file
        update_cwd = true,
    },

    filters = {
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = {
            "node_modules",
            ".DS_Store",
            "tmp",
            "dist",
            ".next",
            ".nuxt",
            ".turbo",
            ".expo",
            "coverage",
            ".cache",
            "target",
            "vendor",
            ".idea",   -- WebStorm config folder
            "*.iml",   -- IntelliJ module files
            ".vscode", -- VS Code config
        },
        exclude = { ".gitignore", ".env", ".editorconfig" },
    },

    filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
            "node_modules",
            ".git",
            ".cache",
            "target",
            "dist",
        },
    },

    git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
    },

    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },

    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        expand_all = {
            max_folder_discovery = 300,
            exclude = { ".git", "target", "build", "node_modules" },
        },
        file_popup = {
            open_win_config = {
                col = 1,
                row = 1,
                relative = "cursor",
                border = "shadow",
                style = "minimal",
            },
        },
        open_file = {
            quit_on_open = false,
            resize_window = false, -- WebStorm keeps consistent sizing
            window_picker = {
                enable = true,
                picker = "default",
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
        remove_file = {
            close_window = true,
        },
    },

    trash = {
        cmd = "gio trash",
    },

    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
    },

    tab = {
        sync = {
            open = false,
            close = false,
            ignore = {},
        },
    },

    notify = {
        threshold = vim.log.levels.INFO,
    },

    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
        },
    },

    -- Add custom keymaps for better CWD navigation
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom CWD navigation
        vim.keymap.set('n', 'C', api.tree.change_root_to_node, {
            buffer = bufnr,
            desc = "Change root to node"
        })
        vim.keymap.set('n', 'u', api.tree.change_root_to_parent, {
            buffer = bufnr,
            desc = "Change root to parent"
        })
        vim.keymap.set('n', '<leader>cd', function()
            local node = api.tree.get_node_under_cursor()
            if node.type == "directory" then
                vim.cmd("cd " .. node.absolute_path)
                api.tree.change_root_to_node()
            end
        end, {
            buffer = bufnr,
            desc = "Change vim CWD to directory"
        })
    end,
}

return options
