-- Performance optimizations
vim.opt.updatetime = 50
vim.opt.timeoutlen = 250
vim.opt.ttimeoutlen = 10
vim.opt.synmaxcol = 200
vim.opt.ttyfast = true
vim.opt.regexpengine = 1
vim.opt.lazyredraw = true
vim.opt.hidden = true
vim.opt.path:append("**")
vim.o.re = 0

-- Disable providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Clean modern UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:1"     -- Single column for cleaner look
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number" -- Only highlight line number
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.pumheight = 15
vim.opt.pumwidth = 35
vim.opt.winminwidth = 10
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.laststatus = 3
vim.opt.showtabline = 2

-- Clean fill characters (minimal and subtle)
vim.opt.fillchars = {
    eob = " ", -- End of buffer (invisible)
    fold = " ", -- Fold lines (clean)
    foldopen = "-", -- Fold open
    foldclose = "+", -- Fold close
    foldsep = " ", -- Fold separator (invisible)
    diff = "╱", -- Diff deleted lines
    msgsep = " ", -- Message separator (clean)
    vert = "│", -- Vertical separator (thin line)
}

-- Minimal list characters (optional, can be disabled)
vim.opt.list = false -- Disable to keep it clean
-- vim.opt.listchars = {
--     tab = "  ",          -- Clean tab
--     trail = " ",         -- Clean trailing spaces
--     extends = " ",       -- Clean extends
--     precedes = " ",      -- Clean precedes
-- }

-- Simple fold settings
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "0" -- No fold column for cleaner look

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "" -- No line break indicator
vim.opt.cpoptions:append(">")

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit" -- Clean preview

-- Files and backup
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.autoread = true
vim.opt.autowrite = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"

-- Clean completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.pumblend = 0 -- No transparency for cleaner look
vim.opt.winblend = 0 -- No transparency

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true

-- Misc
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.virtualedit = "block"
vim.opt.confirm = true
vim.opt.conceallevel = 2

-- Clean command line
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"
vim.opt.wildignorecase = true

-- No bells
vim.opt.belloff = "all"
vim.opt.visualbell = false
vim.opt.errorbells = false

-- Clean syntax
vim.cmd("syntax on")
