vim.opt.guicursor = ""
vim.opt.mouse = "a"
vim.opt.confirm = true
vim.opt.cursorline = true
vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.laststatus = 3
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = ""
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
vim.g.markdown_recommended_style = 0


-- Add this to your init.lua
vim.opt.statusline = [[ %{%v:lua.get_recording_status()%} %f %m %r %=%l,%c %P ]]

-- Define the function globally
function _G.get_recording_status()
    local reg = vim.fn.reg_recording()
    if reg and reg ~= "" then
        return "%#Error#Recording @" .. reg .. "%*" -- Error highlight group makes it red
    end
    return ""
end
