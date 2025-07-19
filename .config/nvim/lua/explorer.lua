local uv = vim.loop
local M = {}

local explorer = { bufnr = nil, winid = nil, cwd = nil, cache = {}, expanded = {} }
local config = {
  width = 30,
  position = 'left',
  icons = { dir = '📁', file = '📄' },
  border = {
    style = 'rounded',
    highlight = 'FloatBorder'
  },
  auto_close = true,
  single_window = true
}

-- Store global keymap IDs for cleanup
local global_keymaps = {}

local function normalize_path(path)
  return path:gsub('\\', '/')
end

local function format_header(path)
  local home = vim.fn.expand('~')
  local display_path = path:gsub('^' .. vim.pesc(home), '~')

  local basename = vim.fn.fnamemodify(display_path, ':t')
  local parent = vim.fn.fnamemodify(display_path, ':h')

  if basename == '' or basename == '.' then
    basename = display_path
    parent = ''
  end

  local header_lines = {}
  local width = config.width

  -- Simple header without borders
  if parent ~= '' and parent ~= '.' then
    local parent_display = parent:len() > width - 4 and '...' .. parent:sub(-(width - 7)) or parent
    table.insert(header_lines, '  ' .. parent_display)
  end

  local basename_display = basename:len() > width - 4 and basename:sub(1, width - 7) .. '...' or basename
  table.insert(header_lines, '> ' .. basename_display)
  table.insert(header_lines, string.rep('─', width))

  return header_lines
end

local function get_default_file_mode()
  return 420 -- 0644 in octal
end

local function get_header_line_count()
  local header = format_header(explorer.cwd)
  return #header + 1
end

local function get_tree_entries(dir, base_dir, level)
  level = level or 0
  base_dir = base_dir or dir

  local items = {}
  local handle = uv.fs_scandir(dir)
  if handle then
    local temp_items = {}
    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then break end
      if name ~= '.' and name ~= '..' then
        table.insert(temp_items, { name = name, type = type })
      end
    end

    table.sort(temp_items, function(a, b)
      if a.type ~= b.type then
        return a.type == 'directory'
      end
      return a.name:lower() < b.name:lower()
    end)

    for _, item in ipairs(temp_items) do
      local full_path = dir .. '/' .. item.name

      local indent = string.rep('  ', level)
      local display_name = indent .. item.name

      table.insert(items, {
        name = item.name,
        display_name = display_name,
        type = item.type,
        path = full_path,
        level = level,
        expanded = explorer.expanded[full_path] or false
      })

      -- If directory is expanded, add its contents
      if item.type == 'directory' and explorer.expanded[full_path] then
        local sub_items = get_tree_entries(full_path, base_dir, level + 1)
        for _, sub_item in ipairs(sub_items) do
          table.insert(items, sub_item)
        end
      end
    end
  end

  return items
end

local function get_entries(dir)
  local cache_key = dir
  if explorer.cache[cache_key] then
    return explorer.cache[cache_key]
  end

  local items = get_tree_entries(dir)
  explorer.cache[cache_key] = items
  return items
end

-- Clean up global keymaps
local function cleanup_global_keymaps()
  for _, keymap_id in ipairs(global_keymaps) do
    pcall(vim.keymap.del, 'n', keymap_id)
  end
  global_keymaps = {}
end

-- Set up global keymaps only when explorer is open
function M.setup_global_keymaps()
  -- Clean up existing keymaps first
  cleanup_global_keymaps()

  -- Helper function to get current file path
  local function get_current_file()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' then
      return nil
    end
    return bufname
  end

  -- Helper function to get file under cursor in explorer
  local function get_explorer_file()
    if not explorer.winid or not vim.api.nvim_win_is_valid(explorer.winid) then
      return nil
    end

    local current_win = vim.api.nvim_get_current_win()
    if current_win ~= explorer.winid then
      return nil
    end

    local line = vim.api.nvim_win_get_cursor(explorer.winid)[1]
    local header_lines = get_header_line_count()
    if line <= header_lines then return nil end

    local entries = get_entries(explorer.cwd)
    local entry_index = line - header_lines
    local entry = entries[entry_index]

    return entry and entry.path or nil
  end

  -- Helper function to get the best file path
  local function get_target_file()
    -- First try to get file from explorer if we're in it
    local explorer_file = get_explorer_file()
    if explorer_file then
      return explorer_file
    end

    -- Otherwise use current buffer
    return get_current_file()
  end

  -- Only set up keymaps if explorer is open
  if not (explorer.winid and vim.api.nvim_win_is_valid(explorer.winid)) then
    return
  end

  vim.keymap.set('n', 'D', function()
    local current_file = get_target_file()
    local file = vim.fn.input('Delete file: ', current_file or '', 'file')
    if file ~= '' then
      vim.cmd('DeleteFile ' .. vim.fn.fnameescape(file))
    end
  end, { desc = 'Delete file' })
  table.insert(global_keymaps, 'D')

  vim.keymap.set('n', 'C', function()
    local current_file = get_target_file()
    local src = vim.fn.input('Copy from: ', current_file or '', 'file')
    if src ~= '' then
      local dest = vim.fn.input('Copy to: ', src, 'file')
      if dest ~= '' and dest ~= src then
        vim.cmd('CopyFile ' .. vim.fn.fnameescape(src) .. ' ' .. vim.fn.fnameescape(dest))
      end
    end
  end, { desc = 'Copy file' })
  table.insert(global_keymaps, 'C')

  vim.keymap.set('n', 'M', function()
    local current_file = get_target_file()
    local src = vim.fn.input('Move from: ', current_file or '', 'file')
    if src ~= '' then
      local dest = vim.fn.input('Move to: ', src, 'file')
      if dest ~= '' and dest ~= src then
        vim.cmd('MoveFile ' .. vim.fn.fnameescape(src) .. ' ' .. vim.fn.fnameescape(dest))
      end
    end
  end, { desc = 'Move/rename file' })
  table.insert(global_keymaps, 'M')

  vim.keymap.set('n', 'a', function()
    local current_dir = explorer.cwd or vim.fn.getcwd()
    local file = vim.fn.input('Create file: ', current_dir .. '/', 'file')
    if file ~= '' then
      vim.cmd('CreateFile ' .. vim.fn.fnameescape(file))
    end
  end, { desc = 'Create file' })
  table.insert(global_keymaps, 'a')

  vim.keymap.set('n', 'md', function()
    local current_dir = explorer.cwd or vim.fn.getcwd()
    local dir = vim.fn.input('Create directory: ', current_dir .. '/', 'file')
    if dir ~= '' then
      local dir_path = dir:sub(-1) == '/' and dir or dir .. '/'
      vim.cmd('CreateFile ' .. vim.fn.fnameescape(dir_path))
    end
  end, { desc = 'Create directory' })
  table.insert(global_keymaps, 'md')
end

local function refresh_explorer_if_open()
  if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
    clear_cache()
    render()
  end
end

-- Helper function to find main window (non-explorer window)
local function find_main_window()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    if win ~= explorer.winid and vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

      if buftype == '' and filetype ~= 'fileexplorer' then
        return win
      end
    end
  end
  return nil
end

-- Helper function to ensure main window exists and is properly sized
local function ensure_main_window()
  local main_win = find_main_window()

  if not main_win then
    -- Check if we have any windows at all
    local windows = vim.api.nvim_list_wins()
    if #windows == 1 and explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
      -- Only explorer window exists, create a new buffer in it temporarily
      vim.api.nvim_set_current_win(explorer.winid)
      vim.cmd('rightbelow vsplit')
      main_win = vim.api.nvim_get_current_win()
      vim.cmd('enew')
    else
      -- Create new window normally
      vim.cmd('enew')
      main_win = vim.api.nvim_get_current_win()
    end
  end

  return main_win
end

local function ensure_dir(path)
  local dir = vim.fn.fnamemodify(normalize_path(path), ":h")
  if dir ~= "" and dir ~= "." and vim.fn.isdirectory(dir) == 0 then
    local ok, err = vim.fn.mkdir(dir, "p")
    if ok ~= 1 then
      error("Failed to create directory: " .. dir .. " - " .. (err or "unknown error"))
    end
  end
end

function M.create(path)
  path = normalize_path(path)

  if path:sub(-1) == '/' then
    local ok, err = vim.fn.mkdir(path, "p")
    if ok ~= 1 then
      error("Failed to create directory: " .. path .. " - " .. (err or "unknown error"))
    end
  else
    ensure_dir(path)
    local fd, err = uv.fs_open(path, "w", get_default_file_mode())
    if not fd then
      error("Failed to create file: " .. path .. " - " .. (err or "unknown error"))
    end
    uv.fs_close(fd)
  end

  refresh_explorer_if_open()
end

function M.remove(path)
  path = normalize_path(path)

  if vim.fn.isdirectory(path) == 1 then
    local ok = vim.fn.delete(path, "rf")
    if ok ~= 0 then
      error("Failed to remove directory: " .. path)
    end
  else
    local ok = vim.fn.delete(path)
    if ok ~= 0 then
      error("Failed to remove file: " .. path)
    end
  end

  refresh_explorer_if_open()
end

function M.move(src, dest)
  src = normalize_path(src)
  dest = normalize_path(dest)

  -- If dest ends with '/', it's a directory - append the source filename
  if dest:sub(-1) == '/' then
    local filename = vim.fn.fnamemodify(src, ':t')
    dest = dest .. filename
  end

  ensure_dir(dest)

  local ok, err = uv.fs_rename(src, dest)
  if ok then
    refresh_explorer_if_open()
    return true
  end

  local result = vim.fn.rename(src, dest)
  if result ~= 0 then
    error("Failed to move " .. src .. " to " .. dest .. " - " .. (err or "unknown error"))
  end

  refresh_explorer_if_open()
  return true
end

function M.copy(src, dest)
  src = normalize_path(src)
  dest = normalize_path(dest)
  if dest:sub(-1) == '/' then
    local filename = vim.fn.fnamemodify(src, ':t')
    dest = dest .. filename
  end

  local stat, err = uv.fs_stat(src)
  if not stat then
    error("Failed to stat source: " .. src .. " - " .. (err or "unknown error"))
  end

  if stat.type == 'directory' then
    local ok, mkdir_err = vim.fn.mkdir(dest, "p")
    if ok ~= 1 then
      error("Failed to create destination directory: " .. dest .. " - " .. (mkdir_err or "unknown error"))
    end

    local handle, scan_err = uv.fs_scandir(src)
    if not handle then
      error("Failed to scan directory: " .. src .. " - " .. (scan_err or "unknown error"))
    end

    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then break end

      if name ~= '.' and name ~= '..' then
        local src_path = src .. '/' .. name
        local dest_path = dest .. '/' .. name
        M.copy(src_path, dest_path)
      end
    end
  else
    ensure_dir(dest)

    local src_fd, src_err = uv.fs_open(src, "r", 0)
    if not src_fd then
      error("Failed to open source file: " .. src .. " - " .. (src_err or "unknown error"))
    end

    local content, read_err = uv.fs_read(src_fd, stat.size, 0)
    uv.fs_close(src_fd)

    if not content then
      error("Failed to read source file: " .. src .. " - " .. (read_err or "unknown error"))
    end

    local dest_fd, dest_err = uv.fs_open(dest, "w", stat.mode or get_default_file_mode())
    if not dest_fd then
      error("Failed to create destination file: " .. dest .. " - " .. (dest_err or "unknown error"))
    end

    local bytes_written, write_err = uv.fs_write(dest_fd, content, 0)
    uv.fs_close(dest_fd)

    if not bytes_written then
      error("Failed to write to destination file: " .. dest .. " - " .. (write_err or "unknown error"))
    end

    if stat.mtime then
      uv.fs_utime(dest, stat.atime.sec, stat.mtime.sec)
    end
  end

  refresh_explorer_if_open()
  return true
end

function clear_cache()
  explorer.cache = {}
end

function render()
  if not explorer.bufnr or not vim.api.nvim_buf_is_valid(explorer.bufnr) then
    return
  end

  local lines = {}

  local header = format_header(explorer.cwd)
  for _, line in ipairs(header) do
    table.insert(lines, line)
  end

  table.insert(lines, '')

  local entries = get_entries(explorer.cwd)
  for _, entry in ipairs(entries) do
    local icon = entry.type == 'directory' and
        (entry.expanded and '📂' or '📁') or
        config.icons.file

    -- Add expand/collapse indicator for directories
    local indicator = ''
    if entry.type == 'directory' then
      indicator = entry.expanded and '▼ ' or '▶ '
    else
      indicator = '  ' -- Space for files to align with directories
    end

    -- Build the display line with proper indentation
    local line = ' ' .. entry.display_name:gsub('^(%s*)', function(spaces)
      return spaces .. indicator .. icon .. ' '
    end)

    table.insert(lines, line)
  end

  local was_modifiable = vim.api.nvim_buf_get_option(explorer.bufnr, 'modifiable')
  vim.api.nvim_buf_set_option(explorer.bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_lines(explorer.bufnr, 0, -1, false, lines)

  if not was_modifiable then
    vim.api.nvim_buf_set_option(explorer.bufnr, 'modifiable', false)
  end
end

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'FileExplorerBorder', {
    fg = '#4a5568',
    bg = 'NONE',
    blend = 20
  })

  vim.api.nvim_set_hl(0, 'FileExplorerHeader', {
    fg = '#a0aec0',
    bg = 'NONE',
    bold = true
  })

  vim.api.nvim_set_hl(0, 'FileExplorerDirectory', {
    fg = '#4299e1',
    bg = 'NONE',
    bold = true
  })

  vim.api.nvim_set_hl(0, 'FileExplorerFile', {
    fg = '#e2e8f0',
    bg = 'NONE'
  })
end

local function setup_buffer_options()
  if not explorer.bufnr then return end

  vim.api.nvim_buf_set_option(explorer.bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(explorer.bufnr, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(explorer.bufnr, 'swapfile', false)
  vim.api.nvim_buf_set_option(explorer.bufnr, 'buflisted', false)
  vim.api.nvim_buf_set_option(explorer.bufnr, 'filetype', 'fileexplorer')
  vim.api.nvim_buf_set_option(explorer.bufnr, 'modifiable', true)

  render()

  vim.api.nvim_buf_call(explorer.bufnr, function()
    vim.cmd([[
      syntax clear
      syntax match FileExplorerBorder /[┌┐└┘─│]/
      syntax match FileExplorerHeader /^│.*│$/
      syntax match FileExplorerDirectory /^\s*📁.*$/
      syntax match FileExplorerFile /^\s*📄.*$/
    ]])
  end)

  vim.api.nvim_buf_set_option(explorer.bufnr, 'modifiable', false)
end

local function setup_window_options()
  if not explorer.winid or not vim.api.nvim_win_is_valid(explorer.winid) then
    return
  end

  vim.api.nvim_win_set_option(explorer.winid, 'number', false)
  vim.api.nvim_win_set_option(explorer.winid, 'relativenumber', false)
  vim.api.nvim_win_set_option(explorer.winid, 'signcolumn', 'no')
  vim.api.nvim_win_set_option(explorer.winid, 'foldcolumn', '0')
  vim.api.nvim_win_set_option(explorer.winid, 'cursorline', true)
  vim.api.nvim_win_set_option(explorer.winid, 'wrap', false)
  vim.api.nvim_win_set_option(explorer.winid, 'spell', false)

  vim.api.nvim_win_set_option(explorer.winid, 'winhighlight',
    'Normal:Normal,FloatBorder:FileExplorerBorder,CursorLine:CursorLine')
end

local function setup_keymaps()
  local opts = { buffer = explorer.bufnr, silent = true, noremap = true }

  vim.keymap.set('n', '<CR>', function()
    local line = vim.api.nvim_win_get_cursor(explorer.winid)[1]
    local header_lines = get_header_line_count()
    if line <= header_lines then return end
    local entries = get_entries(explorer.cwd)
    local entry_index = line - header_lines
    local entry = entries[entry_index]
    if not entry then return end
    if entry.type == 'directory' then
      -- Toggle directory expansion (tree behavior)
      explorer.expanded[entry.path] = not explorer.expanded[entry.path]
      clear_cache()
      render()
    else
      -- Open file in main window
      local main_win = ensure_main_window()
      vim.api.nvim_set_current_win(main_win)
      vim.cmd('edit ' .. vim.fn.fnameescape(entry.path))
      -- Return focus to explorer if auto_close is disabled
      if not config.auto_close then
        vim.api.nvim_set_current_win(explorer.winid)
      end
    end
  end, opts)

  vim.keymap.set('n', 'q', function()
    M.close()
  end, opts)

  vim.keymap.set('n', 'r', function()
    clear_cache()
    render()
  end, opts)

  vim.keymap.set('n', '-', function()
    clear_cache()
    M.open(vim.fn.fnamemodify(explorer.cwd, ':h'))
  end, opts)

  vim.keymap.set('n', 'gg', function()
    local header_lines = get_header_line_count()
    vim.api.nvim_win_set_cursor(explorer.winid, { header_lines + 1, 0 })
  end, opts)

  -- File operations (updated to use entry.path)
  vim.keymap.set('n', 'd', function()
    local line = vim.api.nvim_win_get_cursor(explorer.winid)[1]
    local header_lines = get_header_line_count()
    if line <= header_lines then return end
    local entries = get_entries(explorer.cwd)
    local entry_index = line - header_lines
    local entry = entries[entry_index]
    if not entry then return end

    local confirm = vim.fn.confirm('Delete "' .. entry.name .. '"?', '&Yes\n&No', 2)
    if confirm == 1 then
      M.remove(entry.path)
    end
  end, opts)

  vim.keymap.set('n', 'c', function()
    local line = vim.api.nvim_win_get_cursor(explorer.winid)[1]
    local header_lines = get_header_line_count()
    if line <= header_lines then return end
    local entries = get_entries(explorer.cwd)
    local entry_index = line - header_lines
    local entry = entries[entry_index]
    if not entry then return end

    local dest_name = vim.fn.input('Copy to: ', entry.name)
    if dest_name ~= '' and dest_name ~= entry.name then
      local entry_dir = vim.fn.fnamemodify(entry.path, ':h')
      local dest_path = entry_dir .. '/' .. dest_name
      M.copy(entry.path, dest_path)
    end
  end, opts)

  vim.keymap.set('n', 'm', function()
    local line = vim.api.nvim_win_get_cursor(explorer.winid)[1]
    local header_lines = get_header_line_count()
    if line <= header_lines then return end
    local entries = get_entries(explorer.cwd)
    local entry_index = line - header_lines
    local entry = entries[entry_index]
    if not entry then return end

    local dest_name = vim.fn.input('Move/rename to: ', entry.name)
    if dest_name ~= '' and dest_name ~= entry.name then
      local entry_dir = vim.fn.fnamemodify(entry.path, ':h')
      local dest_path = entry_dir .. '/' .. dest_name
      M.move(entry.path, dest_path)
    end
  end, opts)

  vim.keymap.set('n', 'n', function()
    local name = vim.fn.input('New file name: ')
    if name ~= '' then
      local path = explorer.cwd .. '/' .. name
      M.create(path)
    end
  end, opts)

  vim.keymap.set('n', 'N', function()
    local name = vim.fn.input('New directory name: ')
    if name ~= '' then
      local path = explorer.cwd .. '/' .. name .. '/'
      M.create(path)
    end
  end, opts)
end

-- Set up autocmd to handle external file opens
local function setup_autocmds()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    callback = function()
      if not config.single_window then return end

      local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
      local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

      -- If we're entering a normal file buffer and explorer is open
      if buftype == '' and filetype ~= 'fileexplorer' and
          explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
        vim.schedule(function()
          local current_win = vim.api.nvim_get_current_win()
          local windows = vim.api.nvim_list_wins()

          -- Close all other normal file windows
          for _, win in ipairs(windows) do
            if win ~= explorer.winid and win ~= current_win and vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
              local ft = vim.api.nvim_buf_get_option(buf, 'filetype')

              if bt == '' and ft ~= 'fileexplorer' then
                vim.api.nvim_win_close(win, false)
              end
            end
          end

          -- Ensure proper layout
          vim.cmd('wincmd =')
          if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
            vim.api.nvim_win_set_width(explorer.winid, config.width)
          end
        end)
      end
    end
  })

  -- Set up autocmd to clean up keymaps when explorer closes
  vim.api.nvim_create_autocmd('WinClosed', {
    callback = function()
      vim.schedule(function()
        if not (explorer.winid and vim.api.nvim_win_is_valid(explorer.winid)) then
          cleanup_global_keymaps()
        end
      end)
    end
  })
end

function M.open(dir)
  explorer.cwd = dir or vim.fn.getcwd()

  if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
    clear_cache()
    render()
    return
  end

  setup_highlights()

  -- Check if we need to create a split or if we can use the current window
  local windows = vim.api.nvim_list_wins()
  local has_main_window = false

  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

    if buftype == '' and filetype ~= 'fileexplorer' then
      has_main_window = true
      break
    end
  end

  if has_main_window then
    -- Normal case: create a split
    local split_cmd = config.position == 'left' and 'topleft' or 'botright'
    vim.cmd(split_cmd .. ' ' .. config.width .. 'vsplit')
  else
    -- Edge case: no main window exists, use current window
    -- This handles the "cannot close last window" scenario
  end

  explorer.bufnr = vim.api.nvim_create_buf(false, true)
  explorer.winid = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(explorer.winid, explorer.bufnr)

  setup_buffer_options()
  setup_window_options()
  setup_keymaps()
  clear_cache()

  -- Set up global keymaps when explorer opens
  M.setup_global_keymaps()

  vim.schedule(function()
    if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
      local header_lines = get_header_line_count()
      vim.api.nvim_win_set_cursor(explorer.winid, { header_lines + 1, 0 })
    end
  end)
end

function M.close()
  if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
    -- Check if this is the last window
    local windows = vim.api.nvim_list_wins()
    if #windows > 1 then
      vim.api.nvim_win_close(explorer.winid, true)
    else
      -- If it's the last window, just hide the buffer instead
      vim.api.nvim_win_set_buf(explorer.winid, vim.api.nvim_create_buf(false, true))
    end
    explorer.winid = nil
    -- Clean up global keymaps when explorer closes
    cleanup_global_keymaps()
  end
end

function M.toggle(dir)
  if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
    M.close()
  else
    M.open(dir)
  end
end

function M.focus()
  if explorer.winid and vim.api.nvim_win_is_valid(explorer.winid) then
    vim.api.nvim_set_current_win(explorer.winid)
    return true
  else
    M.open()
    return false
  end
end

function M.setup(opts)
  config = vim.tbl_extend('force', config, opts or {})

  -- Set up autocmds for proper window management
  setup_autocmds()

  vim.api.nvim_create_user_command('Explorer', function(c)
    M.open(c.args ~= '' and c.args or nil)
  end, { nargs = '?', complete = 'dir', desc = 'Open file explorer' })

  vim.api.nvim_create_user_command('ExplorerToggle', function(c)
    M.toggle(c.args ~= '' and c.args or nil)
  end, { nargs = '?', complete = 'dir', desc = 'Toggle file explorer' })

  vim.api.nvim_create_user_command('ExplorerClose', function()
    M.close()
  end, { desc = 'Close file explorer' })

  vim.api.nvim_create_user_command('ExplorerFocus', function()
    M.focus()
  end, { desc = 'Focus file explorer (open if not already open)' })

  -- File operation commands
  vim.api.nvim_create_user_command('DeleteFile', function(c)
    if c.args ~= '' then
      M.remove(c.args)
      print('Deleted: ' .. c.args)
    end
  end, { nargs = 1, complete = 'file', desc = 'Delete file or directory' })

  vim.api.nvim_create_user_command('CopyFile', function(c)
    local args = vim.split(c.args, ' ', { plain = true })
    if #args == 2 then
      M.copy(args[1], args[2])
      print('Copied: ' .. args[1] .. ' -> ' .. args[2])
    end
  end, { nargs = '+', complete = 'file', desc = 'Copy file or directory' })

  vim.api.nvim_create_user_command('MoveFile', function(c)
    local args = vim.split(c.args, ' ', { plain = true })
    if #args == 2 then
      M.move(args[1], args[2])
      print('Moved: ' .. args[1] .. ' -> ' .. args[2])
    end
  end, { nargs = '+', complete = 'file', desc = 'Move/rename file or directory' })

  vim.api.nvim_create_user_command('CreateFile', function(c)
    if c.args ~= '' then
      M.create(c.args)
      print('Created: ' .. c.args)
    end
  end, { nargs = 1, complete = 'file', desc = 'Create file or directory' })
end

return M
