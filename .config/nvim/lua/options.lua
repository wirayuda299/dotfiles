require "nvchad.options"

vim.g.did_load_filetypes = 1
vim.g.did_load_ftplugin = 1
vim.g.did_load_syntax = 1
vim.opt.shadafile = "NONE"
vim.opt.swapfile = false
vim.opt.history = 100 -- default is 10000
vim.opt.scrolljump = 5 -- Jump 5 lines when scrolling off screen
vim.opt.ttimeoutlen = 10 -- Faster key sequence timeout

-- Memory optimization
vim.opt.maxmempattern = 1000 -- Limit pattern matching memory
-- Faster redraw
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.g.loaded_sql_completion = 1
vim.g.loaded_syntax_completion = 1
vim.g.omni_sql_no_default_maps = 1

-- Minimal UI updates
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
-- Reduce updatetime for faster experience (but more CPU)
vim.opt.updatetime = 50 -- default is 4000ms

-- Disable some file detection if you don't need it
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_syntax_completion = 1
vim.g.loaded_fzf = 1 -- if you don't use fzf

-- Health check providers (if you don't use :checkhealth)
vim.g.loaded_health = 1
vim.o.cursorlineopt = "both" -- to enable cursorline!
vim.g.markdown_recommended_style = 0
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.g.nvim_web_devicons_enabled = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.g.editorconfig = false
vim.g.loaded_man = false
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
