local M = {}
M.supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}
local cache = {} ---@type table<(fun()), table<string, any>>

function M.memoize(fn)
  return function(...)
    local key = vim.inspect { ... }
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end
function M.has_config(ctx)
  vim.fn.system { "prettier", "--find-config-path", ctx.filename }
  return vim.v.shell_error == 0
end

function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  if vim.tbl_contains(supported, ft) then
    return true
  end
  local ret = vim.fn.system { "prettier", "--file-info", ctx.filename }
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

M.has_config = M.memoize(M.has_config)
M.has_parser = M.memoize(M.has_parser)

return M
