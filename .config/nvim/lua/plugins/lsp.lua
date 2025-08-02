local analyzers_path = vim.fn.stdpath "data" .. "/mason/packages/sonarlint-language-server/extension/analyzers/"

local sonarlint_ft = {
  "c",
  "cpp",
  "css",
  "docker",
  "go",
  "html",
  "java",
  "javascript",
  "javascriptreact",
  "php",
  "python",
  "typescript",
  "typescriptreact",
  "xml",
  "yaml.docker-compose",
}


return {

  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {},
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
          ensure_installed = {
            "delve", "gopls", "gomodifytags", "gotests", "iferr", "impl", "goimports", "sonarlint-language-server",
            "vscode-spring-boot-tools"
          }
        },
      },
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "jdtls"
          }
        },
        ensure_installed = {
          "lemminx", "lua_ls", "gopls", "tailwindcss", "cssls", "vtsls", "rust_analyzer", "jdtls",
          "angularls", "astro", "neocmake", "clangd", "docker_compose_language_service",
          "dockerls", "html", "emmet_ls",
        },
        automatic_installation = true,
        handlers = require("plugins.configs.lsp")
      })
    end
  },

  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    ft = sonarlint_ft,
    specs = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      server = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          analyzers_path .. "sonargo.jar",
          analyzers_path .. "sonarhtml.jar",
          analyzers_path .. "sonariac.jar",
          analyzers_path .. "sonarjava.jar",
          analyzers_path .. "sonarjavasymbolicexecution.jar",
          analyzers_path .. "sonarjs.jar",
          analyzers_path .. "sonarphp.jar",
          analyzers_path .. "sonarpython.jar",
          analyzers_path .. "sonarxml.jar",
        },
      },
      filetypes = sonarlint_ft,
    },
  },


  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    specs = {
      {
        "mfussenegger/nvim-jdtls",
        optional = true,
        opts = function(_, opts)
          if not opts.init_options then opts.init_options = {} end
          if not opts.init_options.bundles then opts.init_options.bundles = {} end
          vim.list_extend(opts.init_options.bundles, require("spring_boot").java_extensions())
        end,
      },
    },
    opts = {},
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function(_, opts)
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
      vim.fn.mkdir(workspace_dir, "p")

      if not (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1 or vim.fn.has "win32" == 1) then
        vim.notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR)
      end

      return vim.tbl_extend("force", {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
          "-configuration",
          vim.fn.expand "$MASON/share/jdtls/config",
          "-data",
          workspace_dir,
        },
        root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
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
          bundles = {
            vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
            (table.unpack or unpack)(vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n", {})),
          },
        },
        handlers = {
          ["$/progress"] = function() end, -- disable progress updates.
        },
        filetypes = { "java" },

      }, opts)
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "java", -- autocmd to start jdtls
        callback = function()
          if opts.root_dir and opts.root_dir ~= "" then
            require("jdtls").start_or_attach(opts)
          else
            vim.notify("jdtls: root_dir not found. Please specify a root marker", vim.log.levels.ERROR)
          end
        end,
      })
    end,
  },


}
