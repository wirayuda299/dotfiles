local M = {}

-- Cache vim functions for performance
local map = vim.keymap.set
local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic

-- Remove duplicate and unused servers
M.servers = {
  "lua_ls",
  "gopls",
  "ts_ls",
  "tailwindcss",
  "svelte",
  "astro",
  "cssls",
  "html",
  "jsonls",
}



local function setup_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  local mappings = {
    { "n", "gD",         lsp.buf.declaration },
    { "n", "gd",         lsp.buf.definition },
    { "n", "K",          lsp.buf.hover },
    { "n", "<leader>rn", lsp.buf.rename },
    { "n", "<leader>ca", lsp.buf.code_action },
    { "n", "<leader>df", diagnostic.open_float },
    { "n", "[d",         diagnostic.goto_prev },
    { "n", "]d",         diagnostic.goto_next },
    { "i", "<C-h>",      lsp.buf.signature_help },
    { "n", "<space>wa",  lsp.buf.add_workspace_folder },
    { "n", "<space>wr",  lsp.buf.remove_workspace_folder },
  }

  for _, mapping in ipairs(mappings) do
    map(mapping[1], mapping[2], mapping[3], opts)
  end

  map("n", "<space>wl", function()
    print(vim.inspect(lsp.buf.list_workspace_folders()))
  end, opts)
end

M.on_attach = function(client, bufnr)
  setup_keymaps(bufnr)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = (function()
  local capabilities = lsp.protocol.make_client_capabilities()

  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end)()

local diagnostic_config = {
  virtual_text = {
    severity = { min = diagnostic.severity.WARN }, -- Reduce noise
    source = "if_many",
  },
  signs = {
    severity = { min = diagnostic.severity.WARN },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
    max_width = 80,
  },
}

local server_settings = {
  lua_ls = {
    Lua = {
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
          ["${3rd}/luv/library"] = true,
        },
        checkThirdParty = false, -- Disable annoying prompts
      },
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = {
        enable = false, -- Disable telemetry
      },
      hint = {
        enable = true,
      },
    },
  },

  ts_ls = {
    init_options = {
      preferences = {
        disableSuggestions = false,
        includeCompletionsForModuleExports = false, -- Reduce noise
      },
    },
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
      },
    },
  },

  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "tw`([^`]*)",          -- tw`...`
            "tw=\"([^\"]*)",       -- <div tw="..." />
            "tw={\"([^\"}]*)",     -- <div tw={"..."} />
            "tw\\.\\w+`([^`]*)",   -- tw.xxx`...`
            "tw\\(.*?\\)`([^`]*)", -- tw(Component)`...`
          },
        },
      },
    },
  },
}

local lsp_group = api.nvim_create_augroup("LspConfig", { clear = true })

M.defaults = function()
  diagnostic.config(diagnostic_config)

  api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(args)
      local client = lsp.get_client_by_id(args.data.client_id)
      if client then
        M.on_attach(client, args.buf)
      end
    end,
  })

  -- Modern vim.lsp.config approach (0.11+)
  if lsp.config then
    lsp.config("*", {
      capabilities = M.capabilities,
    })

    for server, settings in pairs(server_settings) do
      lsp.config(server, { settings = settings })
    end

    for _, server in ipairs(M.servers) do
      lsp.enable(server)
    end
  else
    local lspconfig = require("lspconfig")
    for _, server in ipairs(M.servers) do
      lspconfig[server].setup({
        capabilities = M.capabilities,
        on_attach = M.on_attach,
        settings = server_settings[server],
      })
    end
  end
end

return M
