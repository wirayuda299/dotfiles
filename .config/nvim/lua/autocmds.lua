local function augroup(name)
  return vim.api.nvim_create_augroup("nvchad_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

local function opts(desc, bufnr)
  return {
    buffer = bufnr,
    desc = "LSP: " .. desc
  }
end

local showDiagnosticSums = function()
  require("troublesum").show()
end

autocmd("LspAttach", {
  group = augroup "lsp_attach",
  callback = function(e)
    local map = vim.keymap.set
    local bufnr = e.buf
    showDiagnosticSums()

    map("n", "<leader>ws", function()
      vim.lsp.buf.workspace_symbol()
    end, opts("workspace symbol", bufnr))
    map("n", "<leader>.", function()
      vim.lsp.buf.code_action()
    end, opts("Code action", bufnr))
    map("n", "<leader>rr", function()
      vim.lsp.buf.references()
    end, opts("References", bufnr))
    map("i", "<c-k>", function()
      vim.lsp.buf.signature_help()
    end, opts("Signature help", bufnr))

    map("n", "[d", function()
      vim.diagnostic.jump({
        count = 1,
        float = true,
        wrap = true,
      })
    end, opts("Next diagnostic", bufnr))
    map("n", "]d", function()
      vim.diagnostic.jump({
        count = -1,
        float = true,
        wrap = true,
      })
    end, opts("Previous diagnostic", bufnr))
  end,
})

autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
