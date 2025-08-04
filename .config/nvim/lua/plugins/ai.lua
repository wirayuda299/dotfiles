return {

  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      require("llm").setup({
        url = "https://api.chatanywhere.com.cn/v1/chat/completions", -- ✅ ChatAnywhere endpoint
        model = "gpt-4o",                                            -- or "gpt-3.5-turbo", "gpt-4"
        api_key = os.getenv("LLM_KEY"),                              -- store your key in env var
        api_type = "openai",
      })
    end,
  },

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
