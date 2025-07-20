return {

  {
    "wirayuda299/numb",
    name = "numb",
    event = "CmdLineEnter"
  },

  {

    "wirayuda299/harppon",
    cmd = { "MarkAdd", "MarkFloat", "MarkJump", "MarkRemove" },
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "javascript", "typescript", "typescriptreact", "svelte", "astro" },
    opts = function()
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
        require("ts-error-translator").translate_diagnostics(err, result, ctx)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
      end
    end
  },


}
