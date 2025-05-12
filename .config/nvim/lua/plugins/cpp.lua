if true then
  return {}
end

return {
  {
    "Civitasv/cmake-tools.nvim",
    name = "cmake-tools.nvim",
    enable = false,
    lazy = true,
    init = function()
      local function try_load()
        if vim.fn.filereadable(vim.fn.getcwd() .. "/CMakeLists.txt") == 1 then
          require("lazy").load { plugins = { "cmake-tools.nvim" } }
        end
      end
      try_load()
      vim.api.nvim_create_autocmd({ "DirChanged", "BufReadPost" }, {
        pattern = "*",
        callback = try_load,
      })
    end,
    opts = {}, -- lazy.nvim bakal auto-setup(opts)
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    enable = false,
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      inlay_hints = { inline = false },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
}
