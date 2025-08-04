local M = {}

function M.map(keys, func, desc, mode, bufnr)
  mode = mode or 'n'
  if func then
    vim.keymap.set(mode, keys, func, {
      bufnr = bufnr,
      desc = 'LSP: ' .. desc,
      silent = true,
      noremap = true
    })
  end
end

function M.diagnostics()
  vim.diagnostic.config({
    signs = false,
    virtual_text = false,
    float = {
      focusable = false,
      style = "minimal",
      border = "none",
      source = "if_many",
      header = "",
      prefix = "",
      max_width = 80,
    },
    update_in_insert = false,
    severity_sort = true,
  })
end

function M.should_disable_for_java()
  -- Check current filetype
  if vim.bo.filetype == "java" then
    return true
  end

  -- Check if it's a Java project
  local java_indicators = {
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'gradlew',
    'mvnw'
  }

  for _, indicator in ipairs(java_indicators) do
    if vim.fn.filereadable(indicator) == 1 then
      return true
    end
  end

  return vim.fn.isdirectory('src/main/java') == 1
end

return M
