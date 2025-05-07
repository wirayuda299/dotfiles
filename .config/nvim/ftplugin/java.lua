-- ~/.config/nvim/ftplugin/java.lua
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  return
end

-- 1. root dir utk project Java
local root_markers = { ".git", "pom.xml", "build.gradle", "mvnw", "gradlew" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

-- 2. workspace folder (bisa pakai nama folder project)
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project_name

-- 3. capabilites default (nvim-cmp)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 4. lokasi jdtls jar & config (Mason install path)
local install_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
local launcher = vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-jar",
    launcher,
    "-configuration",
    install_path .. "/config_linux",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
}

-- 5. start or attach
jdtls.start_or_attach(config)
