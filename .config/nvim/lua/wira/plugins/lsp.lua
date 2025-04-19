local ensure_tools = {
    'stylua',
    'shfmt',
    'gopls',
    'goimports',
    'gofumpt',
    'gomodifytags',
    'impl',
    'delve',
    'typescript-language-server',
    'tailwindcss-language-server',
    'svelte-language-server',
    'astro-language-server',
    'cmake-language-server',
}


return {
    {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        init = function()
            local loaded = false
            local function check()
                local cwd = vim.uv.cwd()
                if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
                    require("lazy").load({ plugins = { "cmake-tools.nvim" } })
                    loaded = true
                end
            end
            check()
            vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    if not loaded then
                        check()
                    end
                end,
            })
        end,
        opts = {},
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
            inlay_hints = {
                inline = false,
            },
            ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
                kind_icons = {
                    Compound = "",
                    Recovery = "",
                    TranslationUnit = "",
                    PackExpansion = "",
                    TemplateTypeParm = "",
                    TemplateTemplateParm = "",
                    TemplateParamObject = "",
                },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'saghen/blink.cmp',
            "stevearc/conform.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
            "j-hui/fidget.nvim",
        },
        build = function()
            local mr = require 'mason-registry'
            mr.refresh(function()
                for _, tool in ipairs(ensure_tools) do
                    local ok, p = pcall(mr.get_package, tool)
                    if ok and not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
        config = function()
            require("conform").setup({
                default_format_opts = {
                    timeout_ms = 3000,
                    async = true,
                    quiet = true,
                    lsp_format = 'fallback',
                },
                formatters_by_ft = {
                    lua = { 'stylua' },
                    javascript = { 'prettier' },
                    javascriptreact = { 'prettier' },
                    typescript = { 'prettier' },
                    typescriptreact = { 'prettier' },
                    go = { 'gofmt', 'goimports' },
                    html = { 'prettier' },
                    css = { 'prettier' },
                    scss = { 'prettier' },
                    json = { 'prettier' },
                    yaml = { 'prettier' },
                    svelte = { 'prettier' },
                }
            })

            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require('fidget').setup {
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            }
            require("mason").setup({
                ensure_installed = { "codelldb", "cmakelang", "cmakelint" }
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "gopls",
                    "clangd",
                },


                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["neocmake"] = function()
                        require("lspconfig").neocmake.setup {
                            capabilities = capabilities,
                        }
                    end,
                    ["clangd"] = function()
                        require("lspconfig").clangd.setup {
                            capabilities = capabilities,
                            keys = {
                                { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                            },
                            root_dir = function(fname)
                                return require("lspconfig.util").root_pattern(
                                        "Makefile",
                                        "configure.ac",
                                        "configure.in",
                                        "config.h.in",
                                        "meson.build",
                                        "meson_options.txt",
                                        "build.ninja"
                                    )(fname) or
                                    require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                                        fname
                                    ) or require("lspconfig.util").find_git_ancestor(fname)
                            end,
                            filetypes = {
                                "c",
                                "cpp",
                                "objc",
                                "objcpp",
                            },
                            cmd = {
                                "clangd",
                                "--background-index",
                                "--clang-tidy",
                                "--header-insertion=iwyu",
                                "--completion-style=detailed",
                                "--function-arg-placeholders",
                                "--fallback-style=llvm",
                            },
                            init_options = {
                                usePlaceholders = true,
                                completeUnimported = true,
                                clangdFileStatus = true,
                            },
                        }
                    end,

                    ['ts_ls'] = function()
                        require('lspconfig').ts_ls.setup {
                            capabilities = capabilities,
                            init_options = {
                                hostInfo = 'neovim',
                                preferences = {
                                    importModuleSpecifierPreference = 'relative',
                                    includePackageJsonAutoImports = 'auto',
                                    quotePreference = 'single',
                                    providePrefixAndSuffixTextForRename = true,
                                    allowIncompleteCompletions = true,
                                },
                            },
                            filetypes = {
                                'javascript',
                                'javascriptreact',
                                'typescript',
                                'typescriptreact',
                            },
                            root_dir = function(fname)
                                return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json',
                                        'jsconfig.json')(fname)
                                    or require('lspconfig.util').find_git_ancestor(fname)
                            end,
                        }
                    end,
                    ['tailwindcss'] = function()
                        require('lspconfig').tailwindcss.setup {
                            capabilities = capabilities,
                            filetypes = {
                                'html',
                                'css',
                                'javascript',
                                'javascriptreact',
                                'typescript',
                                'typescriptreact',
                                'svelte',
                                'astro',
                            },
                        }
                    end,
                    ["gopls"] = function()
                        require('lspconfig').gopls.setup {
                            capabilities = capabilities,
                            cmd = { "gopls", "serve" },
                            filetypes = { 'go', 'gomod' },
                            init_options = {
                                usePlaceholders = true,
                                completeUnimported = true,
                                staticcheck = true,
                            },
                            settings = {
                                gopls = {
                                    analyses = {
                                        unusedparams = true,
                                    },
                                    staticcheck = true,
                                },
                            },
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    format = {
                                        enable = true,
                                        defaultConfig = {
                                            indent_style = "space",
                                            indent_size = "2",
                                        }
                                    },
                                }
                            }
                        }
                    end,
                }
            })


            vim.diagnostic.config({
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
