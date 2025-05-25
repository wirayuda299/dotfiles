local M = {}

local config = {
  show_close_button = true,
  show_modified_indicator = true,
  max_name_length = 20,
  separator = " ",
  colors = {
    active_bg = "#3e4452",
    active_fg = "#abb2bf",
    inactive_bg = "#2c313c",
    inactive_fg = "#5c6370",
    close_fg = "#e06c75",
    modified_fg = "#e5c07b",
    separator_fg = "#4b5263",
  },
}

local function get_buf_name(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return "[No Name]"
  end

  name = vim.fn.fnamemodify(name, ":t") -- Get just filename
  if #name > config.max_name_length then
    name = name:sub(1, config.max_name_length - 3) .. "..."
  end

  return name
end

-- Helper function to check if buffer is modified
local function is_modified(buf)
  return vim.api.nvim_buf_get_option(buf, "modified")
end

-- Get list of listed buffers
local function get_listed_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
      table.insert(buffers, buf)
    end
  end
  return buffers
end

-- Move buffer left
function M.move_buffer_left()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = get_listed_buffers()

  for i, buf in ipairs(buffers) do
    if buf == current_buf and i > 1 then
      -- Swap with previous buffer
      buffers[i], buffers[i - 1] = buffers[i - 1], buffers[i]
      break
    end
  end

  -- Reorder buffers (this is a simplified approach)
  -- In practice, you might want to use a plugin like bufferline.nvim for true reordering
  vim.cmd "redrawtabline"
end

-- Move buffer right
function M.move_buffer_right()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = get_listed_buffers()

  for i, buf in ipairs(buffers) do
    if buf == current_buf and i < #buffers then
      -- Swap with next buffer
      buffers[i], buffers[i + 1] = buffers[i + 1], buffers[i]
      break
    end
  end

  vim.cmd "redrawtabline"
end

-- Close buffer with confirmation if modified
function M.close_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  if is_modified(buf) then
    local choice = vim.fn.confirm("Buffer has unsaved changes. Save before closing?", "&Save\n&Discard\n&Cancel", 3)

    if choice == 1 then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd "write"
      end)
    elseif choice == 3 then
      return -- Cancel
    end
  end

  -- If this is the last buffer, create a new empty one
  local buffers = get_listed_buffers()
  if #buffers <= 1 then
    vim.cmd "enew"
  end

  vim.api.nvim_buf_delete(buf, { force = false })
end

-- Build the tabline string
function M.tabline()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = get_listed_buffers()
  local line = ""

  for i, buf in ipairs(buffers) do
    local is_current = (buf == current_buf)
    local buf_name = get_buf_name(buf)
    local modified = is_modified(buf)

    line = line .. "%#TabLine" .. (is_current and "Sel" or "") .. "#"
    line = line .. "%" .. buf .. "@v:lua.require'bufferline'.switch_to_buffer@"
    line = line .. "" .. buf_name

    -- Modified indicator
    if modified and config.show_modified_indicator then
      line = line .. "%#TabLineModified# +"
      line = line .. "%#TabLine" .. (is_current and "Sel" or "") .. "#"
    end

    -- Close button
    if config.show_close_button then
      line = line .. " "
      line = line .. "%" .. buf .. "@v:lua.require'bufferline'.close_buffer@"
      line = line .. "%#TabLineClose#×%#TabLine" .. (is_current and "Sel" or "") .. "#"
      line = line .. ""
    end

    line = line .. ""

    if i < #buffers then
      line = line .. "%#TabLineSeparator#" .. config.separator
    end
  end

  line = line .. "%#TabLineFill#%T"

  line = line .. "%=%#TabLineNew#%@v:lua.require'bufferline'.new_buffer@ + @"

  return line
end

-- Switch to buffer (called by click)
function M.switch_to_buffer(buf)
  vim.api.nvim_set_current_buf(buf)
end

-- Create new buffer
function M.new_buffer()
  vim.cmd "enew"
end

function M.setup_highlights()
  local colors = config.colors

  vim.api.nvim_set_hl(0, "TabLine", { bg = colors.inactive_bg, fg = colors.inactive_fg })
  vim.api.nvim_set_hl(0, "TabLineSel", { bg = colors.active_bg, fg = colors.active_fg, bold = true })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.inactive_bg })
  vim.api.nvim_set_hl(0, "TabLineClose", { fg = colors.close_fg, bold = true })
  vim.api.nvim_set_hl(0, "TabLineModified", { fg = colors.modified_fg, bold = true })
  vim.api.nvim_set_hl(0, "TabLineSeparator", { fg = colors.separator_fg })
  vim.api.nvim_set_hl(0, "TabLineNew", { fg = colors.active_fg, bold = true })
end

-- Setup the tabline
function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)

  -- Setup highlights
  M.setup_highlights()

  -- Set the tabline function
  vim.o.tabline = "%!v:lua.require'bufferline'.tabline()"
  vim.o.showtabline = 2 -- Always show tabline

  -- Setup keymaps
  local keymap_opts = { noremap = true, silent = true }

  -- Buffer navigation
  vim.keymap.set("n", "<Tab>", ":bnext<CR>", keymap_opts)
  vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", keymap_opts)

  -- Buffer movement
  vim.keymap.set("n", "<leader>bl", M.move_buffer_left, keymap_opts)
  vim.keymap.set("n", "<leader>br", M.move_buffer_right, keymap_opts)

  -- Buffer closing
  vim.keymap.set("n", "<leader>x", function()
    M.close_buffer()
  end, keymap_opts)
  vim.keymap.set("n", "<leader>bD", function()
    M.close_buffer(vim.api.nvim_get_current_buf())
  end, keymap_opts)

  -- New buffer
  vim.keymap.set("n", "<leader>bn", M.new_buffer, keymap_opts)

  -- Buffer selection by number (1-9)
  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
      local buffers = get_listed_buffers()
      if buffers[i] then
        vim.api.nvim_set_current_buf(buffers[i])
      end
    end, keymap_opts)
  end

  -- Auto-update highlights on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = M.setup_highlights,
  })
end

return M
