return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = { "SupermavenUseFree", "SupermavenStatus" },
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },

  {
    "piersolenski/wtf.nvim",
    cmd = { "Wtf" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "gemini"
    },
  }
}
