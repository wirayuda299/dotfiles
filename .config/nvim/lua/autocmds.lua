local function augroup(name)
  return vim.api.nvim_create_augroup("nvchad_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup "lsp_attach",
  callback = function(e)
    local function opts(desc)
      return {
        buffer = e.buf,
        desc = "LSP: " .. desc
      }
    end

    local map = vim.keymap.set
    map("n", "<leader>ws", function()
      vim.lsp.buf.workspace_symbol()
    end, opts("workspace symbol"))
    map("n", "<leader>f", function()
      vim.diagnostic.open_float()
    end, opts("Float diagnostic"))
    map("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, opts("Code action"))
    map("n", "<leader>rr", function()
      vim.lsp.buf.references()
    end, opts("References"))
    map("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, opts("rename"))
    map("i", "<c-k>", function()
      vim.lsp.buf.signature_help()
    end, opts("Signature help"))

    map("n", "[d", function()
      vim.diagnostic.jump({
        count = 1,
        float = true,
        wrap = true,
      })
    end, opts("Next diagnostic"))
    map("n", "]d", function()
      vim.diagnostic.jump({
        count = -1,
        float = true,
        wrap = true,
      })
    end, opts("Previous diagnostic"))
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
