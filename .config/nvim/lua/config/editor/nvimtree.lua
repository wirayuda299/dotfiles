local options = {
    disable_netrw = true,
    hijack_netrw = true,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    view = {
        width = 35,
        side = "left",
        preserve_window_proportions = true,
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "name",
        indent_markers = { enable = true },
        icons = {
            show = {
                folder_arrow = false,
            },
            glyphs = {
                folder = {
                    arrow_closed = "▶",
                    arrow_open = "▼",
                },
            },
        },
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", ".git", ".DS_Store" },
    },
    git = { ignore = false },
    actions = {
        open_file = {
            quit_on_open = false,
            resize_window = true,
        },
    },
}
return options
