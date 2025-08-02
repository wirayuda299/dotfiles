local M = {}
local jdtls = require('jdtls')

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

local function get_jdtls_paths()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

  if vim.fn.isdirectory(mason_path) == 0 then
    error("JDTLS not found. Please install it with :MasonInstall jdtls")
  end

  local launcher_pattern = mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
  local launcher_files = vim.split(vim.fn.glob(launcher_pattern), '\n')
  launcher_files = vim.tbl_filter(function(file) return file ~= '' end, launcher_files)

  if #launcher_files == 0 then
    error("Could not find JDTLS launcher jar. Expected pattern: " .. launcher_pattern)
  end

  local launcher_jar = launcher_files[1] -- Use the first (should be only) match

  local os_config = "config_linux"
  if vim.fn.has("mac") == 1 then
    os_config = "config_mac"
  elseif vim.fn.has("win32") == 1 then
    os_config = "config_win"
  end

  local config_dir = mason_path .. "/" .. os_config

  if vim.fn.filereadable(launcher_jar) == 0 then
    error("JDTLS launcher jar not readable: " .. launcher_jar)
  end
  if vim.fn.isdirectory(config_dir) == 0 then
    error("JDTLS config directory not found: " .. config_dir)
  end

  return launcher_jar, config_dir
end

local launcher_jar, config_dir = get_jdtls_paths()

local config = {
  cmd = {
    "/usr/bin/java",

    -- Performance JVM flags
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=WARN",

    -- Memory and GC optimization
    "-Xmx4g",
    "-Xms1g",
    "-XX:+UseG1GC",
    "-XX:G1HeapRegionSize=32m",
    "-XX:+UseStringDeduplication",

    -- Module system
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "--add-opens", "java.base/java.io=ALL-UNNAMED",
    "--add-opens", "java.base/java.nio=ALL-UNNAMED",

    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  root_dir = jdtls.setup.find_root({ "gradlew", ".git", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts" }),

  settings = {
    java = {
      maxConcurrentBuilds = 2,
      import = {
        gradle = { enabled = true, wrapper = { enabled = true } },
        maven = { enabled = true },
        exclusions = {
          "**/node_modules/**",
          "**/.git/**",
          "**/build/**",
          "**/target/**",
          "**/.gradle/**",
          "**/bin/**",
        },
      },

      compile = {
        nullAnalysis = { mode = "automatic" },
      },
      completion = {
        maxResults = 50,
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "org.mockito.Answers.*"
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },

      -- Configuration tweaks
      configuration = {
        updateBuildConfiguration = "automatic",
      },

      -- Format settings
      format = {
        enabled = true,
      },

      -- Sources organization
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },

  init_options = {
    bundles = {},
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },


  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, opts)
    vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, opts)
    vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, opts)
    vim.keymap.set('v', '<leader>jm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
  end,
}

function M.setup()
  -- Optimize Neovim settings for LSP
  vim.opt.updatetime = 300

  -- Start or attach JDTLS
  jdtls.start_or_attach(config)
end

return M
