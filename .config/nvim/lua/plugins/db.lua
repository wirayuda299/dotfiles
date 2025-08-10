return {
  {
    "tpope/vim-dadbod",
    ft = { "sql", "mysql", "plsql" },
    cmd = { "DB" }, -- Commands from vim-dadbod itself
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" }, -- Clean dependency
    cmd = {
      "DBUI",
      "DBUIToggle", 
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      { "<C-d>", "<cmd>DBUIToggle<cr>", silent = true } -- Move key here
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" }, -- Load with SQL files
  }
}
