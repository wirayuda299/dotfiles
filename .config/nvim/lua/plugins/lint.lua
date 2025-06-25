return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        linters_by_ft = {
            javascript = { "oxlint", "biomejs" },
            typescript = { "oxlint", "biomejs" },
            javascriptreact = { "oxlint", "biomejs" },
            typescriptreact = { "oxlint", "biomejs" },
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
                "--quiet", -- Reduce output
            },
            stream = "stdout",
            ignore_exitcode = true,
            parser = lint.linters.oxlint.parser,
        }
        lint.linters.biomejs = {
            cmd = "biome",
            stdin = true,
            args = {
                "lint",
                "--stdin-file-path",
                function() return vim.api.nvim_buf_get_name(0) end,
                "--config-path",
                vim.fn.expand("~/.biome.json"),
                "--reporter=json",
                "--no-errors-on-unmatched", -- Prevent errors on unmatched files
            },
            stream = "stdout",
            ignore_exitcode = true,
            parser = require("lint.linters.biomejs").parser,
        }

        local lint_timer = nil
        local function debounced_lint(delay)
            if lint_timer then
                lint_timer:stop()
            end
            lint.try_lint()
        end

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint-save", { clear = true }),
            callback = function()
                lint.try_lint()
            end,
        })

        vim.api.nvim_create_autocmd({ "BufReadPost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint-read", { clear = true }),
            callback = function()
                debounced_lint(100)
            end,
        })
    end,
}
