return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc" },
    settings = {
        Lua = {
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                    ["${3rd}/luv/library"] = true,
                },
                checkThirdParty = false, -- Disable annoying prompts
            },
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = {
                enable = false, -- Disable telemetry
            },
            hint = {
                enable = true,
            },
        },
    }
}
