local api = vim.api
local uv = vim.uv or vim.loop

-- Pre-computed textobject mappings for better readability and performance
local textobject_mappings = {
  goto_next_start = {
    ["]f"] = "@function.outer",
    ["]c"] = "@class.outer",
    ["]a"] = "@parameter.inner"
  },
  goto_next_end = {
    ["]F"] = "@function.outer",
    ["]C"] = "@class.outer",
    ["]A"] = "@parameter.inner"
  },
  goto_previous_start = {
    ["[f"] = "@function.outer",
    ["[c"] = "@class.outer",
    ["[a"] = "@parameter.inner"
  },
  goto_previous_end = {
    ["[F"] = "@function.outer",
    ["[C"] = "@class.outer",
    ["[A"] = "@parameter.inner"
  },
}

-- Optimized file size checking with caching
local file_size_cache = {}
local max_filesize = 100 * 1024 -- 100 KB

local function should_disable_highlight(lang, buf)
  -- Always disable HTML (as per your original logic)
  if lang == "html" then
    return true
  end

  -- Get buffer name once
  local bufname = api.nvim_buf_get_name(buf)
  if bufname == "" then
    return false
  end

  -- Check cache first
  if file_size_cache[bufname] ~= nil then
    return file_size_cache[bufname] > max_filesize
  end

  -- Get file stats and cache result
  local ok, stats = pcall(uv.fs_stat, bufname)
  if ok and stats then
    file_size_cache[bufname] = stats.size
    return stats.size > max_filesize
  end

  -- Default to enabled if we can't get stats
  file_size_cache[bufname] = 0
  return false
end

-- Optimized language list (grouped by usage frequency for better cache locality)
local ensure_installed = {
  -- Web development (most common)
  "javascript",
  "typescript",
  "html",
  "css",
  "json",

  -- Modern frameworks
  "svelte",
  "astro",

  -- System/scripting
  "lua",
  "bash",

  -- Go ecosystem
  "go",
  "gomod",
  "gowork",
  "gosum",

  -- Documentation
  "jsdoc",
  "markdown",
}

-- Clear cache periodically to prevent memory leaks
local function setup_cache_cleanup()
  local timer = uv.new_timer()
  if timer then
    timer:start(300000, 300000, function() -- Every 5 minutes
      file_size_cache = {}
    end)
  end
end

-- Setup cache cleanup on first load
setup_cache_cleanup()

return {
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- Add jumps to jumplist
      goto_next_start = textobject_mappings.goto_next_start,
      goto_next_end = textobject_mappings.goto_next_end,
      goto_previous_start = textobject_mappings.goto_previous_start,
      goto_previous_end = textobject_mappings.goto_previous_end,
    },
  },

  ensure_installed = ensure_installed,

  highlight = {
    enable = true,
    use_languagetree = true,
    disable = should_disable_highlight,
    -- Performance optimizations
    additional_vim_regex_highlighting = false, -- Disable vim regex highlighting
  },

  indent = {
    enable = true,
    -- Disable for problematic languages if needed
    disable = { "python", "yaml" }, -- Common problematic ones
  },

  -- Performance optimizations
  sync_install = false, -- Don't block on install
  auto_install = false, -- Prevent automatic installs that can slow startup

  -- Incremental selection (useful and performant)
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<S-CR>",
      node_decremental = "<BS>",
    },
  },
}
