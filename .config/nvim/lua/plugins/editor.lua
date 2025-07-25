return {
  {
    "wirayuda299/harppon",
    name = "harpoon",
    cmd = { "MarkAdd", "MarkFloat", "MarkJump", "MarkRemove" },
    keys = {
      { "<leader>ma", "<cmd>MarkAdd<cr>",    silent = true },
      { "<leader>mf", "<cmd>MarkFloat<cr>",  silent = true },
      { "<leader>mr", "<cmd>MarkRemove<cr>", silent = true },
      { "<leader>1",  "<cmd>MarkJump 1<cr>", silent = true },
      { "<leader>2",  "<cmd>MarkJump 2<cr>", silent = true },
      { "<leader>3",  "<cmd>MarkJump 3<cr>", silent = true },
      { "<leader>4",  "<cmd>MarkJump 4<cr>", silent = true },
      { "<leader>5",  "<cmd>MarkJump 5<cr>", silent = true },

    }
  },



  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = { "SupermavenUseFree", "SupermavenStatus" },
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },

}
