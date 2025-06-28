local options = {
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                -- File management
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",

                -- Archive handling
                "gzip",
                "tar",
                "tarPlugin",
                "zip",
                "zipPlugin",
                "vimball",
                "vimballPlugin",

                -- HTML/conversion
                "2html_plugin",
                "tohtml",

                -- Script fetching
                "getscript",
                "getscriptPlugin",

                -- Matching/syntax (if using treesitter)
                "matchit",
                "matchparen",
                "syntax",
                "synmenu",

                -- Misc utilities
                "logipat",
                "tutor",
                "optwin",
                "compiler",
                "bugreport",
                "rrhelper",
                "spellfile_plugin",
                "rplugin",
                "ftplugin",
            },
        },
    },
    defaults = {
        lazy = true,
        version = false, -- Use latest commits for faster updates
    },
    -- Additional performance options
    install = {
        missing = true,
    },
    checker = {
        enabled = false, -- Disable automatic update checking
        notify = false,
    },
    change_detection = {
        enabled = false, -- Disable config change detection
        notify = false,
    },
    ui = {
        backdrop = 100, -- Fully opaque backdrop for better performance
    },
}

return options
