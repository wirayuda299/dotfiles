local M = {}
local map = vim.keymap.set

local lsp_buf = vim.lsp.buf
local diagnostic = vim.diagnostic

M.on_attach = function(_, bufnr)
    local buf_opts = { buffer = bufnr }
    map("n", "gD", lsp_buf.declaration, vim.tbl_extend("force", buf_opts, { desc = "LSP: Go to declaration" }))
    map("n", "gd", lsp_buf.definition, vim.tbl_extend("force", buf_opts, { desc = "LSP: Go to definition" }))
    map("n", "gi", lsp_buf.implementation, vim.tbl_extend("force", buf_opts, { desc = "LSP: Go to implementation" }))
    map(
        { "n", "v" },
        "<leader>ca",
        lsp_buf.code_action,
        vim.tbl_extend("force", buf_opts, { desc = "LSP: Code action" })
    )
    map("n", "gr", lsp_buf.references, vim.tbl_extend("force", buf_opts, { desc = "LSP: References" }))
    map("n", "[d", diagnostic.goto_next, vim.tbl_extend("force", buf_opts, { desc = "LSP: Go to next diagnostic" }))
    map("n", "]d", diagnostic.goto_prev, vim.tbl_extend("force", buf_opts, { desc = "LSP: Go to prev diagnostic" }))
end

M.on_init = function(client)
    if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end

    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    },
}

function M.setup()
    local lspconfig = require("lspconfig")

    local servers = {
        "lua_ls",
        "clangd",
        "gopls",
        "ts_ls",
        "tailwindcss",
        "svelte",
        "astro",
        "cssls",
        "css_variables",
        "cssmodules_ls",
        "dockerls",
        "html",
        "jsonls",
        "cmake",
        "jdtls",
        "rust_analyzer",
    }

    local default_config = {
        on_attach = M.on_attach,
        on_init = M.on_init,
        capabilities = M.capabilities,
        flags = { debounce_text_changes = 150 },
    }

    for _, srv in ipairs(servers) do
        lspconfig[srv].setup(default_config)
    end

    lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_config, {
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = {
                        vim.fn.stdpath("config") .. "/lua",
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    },
                    maxPreload = 100,
                    preloadFileSize = 100,
                },
            },
        },
    }))
end

return M
