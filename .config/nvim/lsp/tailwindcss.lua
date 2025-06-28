return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = {
        -- html
        "aspnetcorerazor",
        "astro",
        "astro-markdown",
        "blade",
        "clojure",
        "django-html",
        "htmldjango",
        "edge",
        "eelixir", -- vim ft
        "elixir",
        "ejs",
        "erb",
        "eruby", -- vim ft
        "gohtml",
        "gohtmltmpl",
        "haml",
        "handlebars",
        "hbs",
        "html",
        "htmlangular",
        "html-eex",
        "heex",
        "jade",
        "leaf",
        "liquid",
        "markdown",
        "mdx",
        "mustache",
        "njk",
        "nunjucks",
        "php",
        "razor",
        "slim",
        "twig",
        -- css
        "css",
        "less",
        "postcss",
        "sass",
        "scss",
        "stylus",
        "sugarss",
        -- js
        "javascript",
        "javascriptreact",
        "reason",
        "rescript",
        "typescript",
        "typescriptreact",
        -- mixed
        "vue",
        "svelte",
        "templ",
    },
    root_dir = function(bufnr, on_dir)
        local function root_marker_with_field(root_files, new_names, field, fname)
            local path = vim.fn.fnamemodify(fname, ':h')
            local found = vim.fs.find(new_names, { path = path, upward = true })

            for _, f in ipairs(found or {}) do
                for line in io.lines(f) do
                    if line:find(field) then
                        root_files[#root_files + 1] = vim.fs.basename(f)
                        break
                    end
                end
            end
            return root_files
        end
        local function insert_package_json(root_files, field, fname)
            return root_marker_with_field(root_files, { 'package.json', 'package.json5' }, field, fname)
        end
        local root_files = {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "postcss.config.js",
            "postcss.config.cjs",
            "postcss.config.mjs",
            "postcss.config.ts",
        }

        local fname = vim.api.nvim_buf_get_name(bufnr)
        root_files = insert_package_json(root_files, 'tailwindcss', fname)
        root_files = root_marker_with_field(root_files, { 'mix.lock' }, 'tailwind', fname)
        on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
    end,
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
            },
            classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
            },
            includeLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
                templ = "html",
                htmlangular = "html",
            },
        },
    },
    before_init = function(_, config)
        if not config then
            config.settings = {}
        end
        if not config.settings.editor then
            config.settings.editor = {}
        end
        if not config.settings.editor.tabSize then
            config.settings.editor.tabSize = {}
        end
    end,
    workspace_required = true,
    root_markers = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
    },
}
