return {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" },
    opts = {
        linters_by_ft = {
            javascript = { "oxlint" },
            typescript = { "oxlint" },
            javascriptreact = { "oxlint" },
            typescriptreact = { "oxlint" },
        },
    },
    config = function(_, opts)
        local lint = require("lint")
        lint.linters_by_ft = opts.linters_by_ft

        lint.linters.oxlint = {
            cmd = "oxlint",
            stdin = true,
            args = {
                "--format=json",
                "--quiet",
            },
            stream = "stdout",
            ignore_exitcode = true,
            parser = lint.linters.oxlint.parser,
        }

        local lint_timer = nil
        local function debounced_lint(delay)
            if lint_timer then
                lint_timer:stop()
            end
            lint_timer = vim.defer_fn(function()
                lint.try_lint()
            end, delay or 500)
        end

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint-save", { clear = true }),
            callback = function()
                debounced_lint(100)
            end,
        })

        vim.api.nvim_create_autocmd({ "BufReadPost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint-read", { clear = true }),
            callback = function()
                debounced_lint(1000)
            end,
        })
    end,
}
