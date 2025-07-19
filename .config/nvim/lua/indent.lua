-------------------------------------- simple indent lines using listchars ------------------------------------------
-- Enable list mode to show listchars
vim.opt.list = true

-- Set up listchars with indent guides
vim.opt.listchars = {
  tab = "│ ", -- Show tabs as vertical line + space
  leadmultispace = "│" .. string.rep(" ", vim.o.shiftwidth - 1), -- Show leading spaces as indent guides
  trail = "·", -- Show trailing spaces
  extends = "›", -- Show when line extends beyond screen
  precedes = "‹", -- Show when line precedes beyond screen
  nbsp = "␣", -- Show non-breaking spaces
}

-- Function to check if we should show listchars
local function should_show_listchars()
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype

  -- Skip special buffer types and filetypes
  local skip_filetypes = {
    'help', 'terminal', 'prompt', 'qf', 'quickfix', 'loclist',
    'mason', 'lazy', 'lazyterm', 'TelescopePrompt', 'TelescopeResults',
    'neo-tree', 'NvimTree', 'packer', 'alpha', 'dashboard',
    'startify', 'fugitive', 'gitcommit', 'gitrebase',
    'lspinfo', 'lsp-installer', 'null-ls-info',
    'toggleterm', 'fterm', 'Trouble', 'vista', 'tagbar',
    'undotree', 'diff', 'oil', 'noice', 'notify',
    'WhichKey', 'checkhealth', 'man', 'lspinstall'
  }

  if buftype ~= '' and buftype ~= 'acwrite' then
    return false
  end

  for _, ft in ipairs(skip_filetypes) do
    if filetype == ft then
      return false
    end
  end

  return true
end

-- Auto command to toggle listchars based on buffer
local listchars_group = vim.api.nvim_create_augroup("SmartListchars", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = listchars_group,
  callback = function()
    if should_show_listchars() then
      vim.opt_local.list = true
    else
      vim.opt_local.list = false
    end
  end,
})

-- Toggle function
local function toggle_listchars()
  vim.opt_local.list = not vim.opt_local.list
end

vim.keymap.set("n", "<leader>tl", toggle_listchars, { desc = "Toggle listchars" })
