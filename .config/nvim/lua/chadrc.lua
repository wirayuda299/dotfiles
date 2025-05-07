---@type ChadrcConfig
local M = {}

M.base46 = {
   hl_override = {
      Comment = { italic = true },
      ["@comment"] = { italic = true },
   },
}

M.ui = {
   transparent = false,
   tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
      bufwidth = 21,
   },
   nvdash = {
      load_on_startup = false,
   },
   cmp = {
      icons = true,
      lspkind_text = true,
      style = "default",
      border_color = "default",
      selected_item_bg = "colored",
   },
}
return M
