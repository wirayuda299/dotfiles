local M = {}

local map = vim.keymap.set

M.servers = {
    "lua_ls",
    "gopls",
    "ts_ls",
    "tailwindcss",
    "cssls",
    "css_variables",
    "cssmodules_ls",
}

M.on_attach = function(_, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))

    map("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts("workspace symbol"))

    map("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts("Code action"))
    map("n", "<leader>rr", function()
        vim.lsp.buf.references()
    end, opts("References"))
    map("i", "<c-k>", function()
        vim.lsp.buf.signature_help()
    end, opts("Signature help"))

    map("n", "[d", function()
        vim.diagnostic.jump({
            count = 1,
            float = true,
            wrap = true,
        })
    end, opts("Next diagnostic"))
    map("n", "]d", function()
        vim.diagnostic.jump({
            count = -1,
            float = true,
            wrap = true,
        })
    end, opts("Previous diagnostic"))
end

M.on_init = function(client, _)
    if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end
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
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

M.defaults = function()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            M.on_attach(_, args.buf)
        end,
    })

    if vim.lsp.config then
        vim.lsp.config("*", { capabilities = M.capabilities })

        vim.lsp.enable(M.servers)
    end
end

return M
