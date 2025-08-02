return {
  "tpope/vim-dadbod",
  config = function()
    local data_path = vim.fn.stdpath("data")
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
    vim.g.db_ui_execute_on_save = false
  end,
  ft = { "sql", "mysql", "plsql" },
  keys = {
    { "<C-d>", "<cmd>DBUIToggle<cr>", { silent = true } }
  },
  specs = {
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = { "tpope/vim-dadbod" },
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
    },
    {
      "kristijanhusak/vim-dadbod-completion",
      lazy = true,
      specs = {
        {
          "saghen/blink.cmp",
          opts = {
            sources = {
              per_filetype = {
                sql = { "snippets", "dadbod", "buffer" },
              },
              providers = {
                dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
              },
            },
          },
        },
      },
    },
  },
}
