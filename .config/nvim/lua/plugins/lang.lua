return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    root_dir = { ".luarc.json", ".git" },
    -- library = {
    --   { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --   -- "${3rd}/love2d/library",
    -- },
  },


  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "javascript", "typescript", "typescriptreact", "svelte", "astro" },
  },


}
