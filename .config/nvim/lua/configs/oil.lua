return {
  delete_to_trash = true,
  default_file_explorer = true,
  columns = {}, -- Try empty columns to remove all extra columns
  view_options = {
    show_hidden = false,
  },
  float = {
    max_width = 0.6,
    max_height = 0.6,
    padding = 2,
    border = "rounded",
  },
  -- Try disabling syntax highlighting which might be causing the numbers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
}
