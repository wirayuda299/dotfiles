return {
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {},
  },

  -- clangd UI extensions
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {},
  },

  -- LSP UI enhancements on attach
  {
    "jinzhongjia/LspUI.nvim",
    event = "LspAttach",
    config = function()
      require("LspUI").setup({})
    end,
  },

  -- Core LSPConfig + Mason integration for many languages
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
          ensure_installed = {
            "delve", "gopls", "gomodifytags", "gotests", "iferr",
            "impl", "goimports", "sonarlint-language-server", "vscode-spring-boot-tools"
          },
        },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
      },
    },
    config = function()
      local mlsp = require("mason-lspconfig")
      mlsp.setup({
        ensure_installed = {
          "lemminx", "lua_ls", "gopls", "tailwindcss", "cssls",
          "vtsls", "rust_analyzer", "jdtls", "angularls", "astro",
          "neocmake", "clangd", "docker_compose_language_service",
          "dockerls", "html", "emmet_ls",
        },
        automatic_installation = true,
      })
      -- load user handlers
      require("plugins.configs.lsp")
    end,
  },

  -- Java LSP (jdtls) only when opening Java files
  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
      { "neovim/nvim-lspconfig" },  -- lspconfig is loaded above
    },
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local ws = vim.fn.stdpath("data")
                .. "/site/java/workspace-root/"
                .. project_name
      vim.fn.mkdir(ws, "p")

      require('lspconfig').jdtls.setup({
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar"),
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.expand("$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar"),
          "-configuration", vim.fn.expand("$MASON/share/jdtls/config"),
          "-data", ws,
        },
        root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = 'interactive' },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = 'all' } },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        init_options = {
          bundles = vim.tbl_flatten({
            vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar", true, true),
            vim.fn.glob("$MASON/share/java-test/*.jar", true, true),
          }),
        },
        handlers = { ["$/progress"] = function() end },
      })
    end,
  },
}
