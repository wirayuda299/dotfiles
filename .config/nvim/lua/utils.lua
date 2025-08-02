local M = {}


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
