local M = {}
local file_cache = {}
function M.should_attach_lsp(bufnr)
  local max_filesize = 100 * 1024
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" or name:match("^%w+://") then
    return false
  end

  -- Cache file size checks
  if file_cache[name] == nil then
    local ok, stats = pcall(vim.uv.fs_stat, name)
    file_cache[name] = (ok and stats and stats.size <= max_filesize) or false
  end

  return file_cache[name]
end

function M.map(keys, func, desc, mode, bufnr)
  mode = mode or 'n'
  if func then
    vim.keymap.set(mode, keys, func, {
      buffer = bufnr,
      desc = 'LSP: ' .. desc,
      silent = true,
      noremap = true
    })
  end
end

function M.diagnostics()
  vim.diagnostic.config({
    signs = false,
    virtual_text = {
      spacing = 2,
      source = false,
    },
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

return M
