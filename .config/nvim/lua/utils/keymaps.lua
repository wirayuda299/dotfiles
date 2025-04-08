local M = {}

function M.safe_keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false -- default to silent = true

  -- In VSCode, disable remap (if set)
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end

  -- Always make sure mode is a table
  local modes = type(mode) == 'string' and { mode } or mode

  vim.keymap.set(modes, lhs, rhs, opts)
end

return M
