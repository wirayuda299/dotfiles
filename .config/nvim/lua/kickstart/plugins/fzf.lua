return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  opts = function(_, opts)
    local fzf = require 'fzf-lua'
    local config = fzf.config
    local actions = fzf.actions

    -- Quickfix key mappings
    config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
    config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
    config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
    config.defaults.keymap.fzf['ctrl-x'] = 'jump'
    config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
    config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
    config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
    config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

    -- Toggle root dir / cwd mapping
    config.defaults.actions.files['ctrl-r'] = function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = not o.root
      o.cwd = nil
      o.buf = ctx.__CTX.bufnr
      require('fzf-lua').files(o)
    end
    config.defaults.actions.files['alt-c'] = config.defaults.actions.files['ctrl-r']
    config.set_action_helpstr(config.defaults.actions.files['ctrl-r'], 'toggle-root-dir')

    -- Determine an image previewer, if available
    local img_previewer ---@type string[]?
    for _, v in ipairs {
      { cmd = 'ueberzug', args = {} },
      { cmd = 'chafa', args = { '{file}', '--format=symbols' } },
      { cmd = 'viu', args = { '-b' } },
    } do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end

    return {
      'default-title',
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = true,
      },
      defaults = {
        formatter = 'path.dirname_first',
      },
      previewers = {
        builtin = {
          extensions = {
            ['png'] = img_previewer,
            ['jpg'] = img_previewer,
            ['jpeg'] = img_previewer,
            ['gif'] = img_previewer,
            ['webp'] = img_previewer,
          },
          ueberzug_scaler = 'fit_contain',
        },
      },
      -- Override vim.ui.select to use fzf-lua's UI select
      ui_select = function(fzf_opts, items)
        return vim.tbl_deep_extend('force', fzf_opts, {
          prompt = ' ',
          winopts = {
            title = ' ' .. vim.trim((fzf_opts.prompt or 'Select'):gsub('%s*:%s*$', '')) .. ' ',
            title_pos = 'center',
          },
        }, (fzf_opts.kind == 'codeaction') and {
          winopts = {
            layout = 'vertical',
            -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
            width = 0.5,
            preview = {
              layout = 'vertical',
              vertical = 'down:15,border-top',
              hidden = 'hidden',
            },
          },
        } or {
          winopts = {
            width = 0.5,
            height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
          },
        })
      end,
      winopts = {
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          scrollchars = { '┃', '' },
        },
      },
      files = {
        cwd_prompt = false,
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      grep = {
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      lsp = {
        symbols = {
          symbol_hl = function(s)
            return 'TroubleIcon' .. s
          end,
          symbol_fmt = function(s)
            return s:lower() .. '\t'
          end,
          child_prefix = false,
        },
        code_actions = {
          previewer = vim.fn.executable 'delta' == 1 and 'codeaction_native' or nil,
        },
      },
    }
  end,
  config = function(_, opts)
    -- Allow using a base profile ("default-title") for a consistent prompt
    if opts[1] == 'default-title' then
      local function fix(t)
        t.prompt = t.prompt ~= nil and ' ' or nil
        for _, v in pairs(t) do
          if type(v) == 'table' then
            fix(v)
          end
        end
        return t
      end
      opts = vim.tbl_deep_extend('force', fix(require 'fzf-lua.profiles.default-title'), opts)
      opts[1] = nil
    end
    require('fzf-lua').setup(opts)
  end,
  init = function()
    -- Replace vim.ui.select with fzf-lua's registered UI select
    local original_ui_select = vim.ui.select
    vim.ui.select = function(...)
      require('fzf-lua').register_ui_select()
      return original_ui_select(...)
    end
  end,
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '<leader>,', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'Switch Buffer' },
    { '<leader>/', '<cmd>FzfLua live_grep<cr>', desc = 'Grep (Root Dir)' },
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },

    {
      '<leader><space>',
      function()
        require('fzf-lua').files {
          fd_opts = '--hidden --exclude .git --exclude node_modules --exclude dist --exclude .cache',
        }
      end,

      desc = 'Find Files (Root Dir)',
    },
    { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
    { '<leader>fc', '<cmd>FzfLua files ~/.config/nvim<cr>', desc = 'Find Config File' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find Files (Root Dir)' },
    { '<leader>fF', '<cmd>FzfLua files cwd=false<cr>', desc = 'Find Files (cwd)' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Find Files (git-files)' },
    { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
    { '<leader>fR', '<cmd>FzfLua oldfiles cwd=' .. vim.fn.getcwd() .. '<cr>', desc = 'Recent (cwd)' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Commits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Status' },
    { '<leader>s"', '<cmd>FzfLua registers<cr>', desc = 'Registers' },
    { '<leader>sa', '<cmd>FzfLua autocmds<cr>', desc = 'Auto Commands' },
    { '<leader>sb', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Buffer' },
    { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
    { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep (Root Dir)' },
    { '<leader>sG', '<cmd>FzfLua live_grep cwd=false<cr>', desc = 'Grep (cwd)' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumplist' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'Location List' },
    { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Jump to Mark' },
    { '<leader>sR', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = 'Word (Root Dir)' },
    { '<leader>sW', '<cmd>FzfLua grep_cword cwd=false<cr>', desc = 'Word (cwd)' },
    { '<leader>sw', '<cmd>FzfLua grep_visual<cr>', mode = 'v', desc = 'Selection (Root Dir)' },
    { '<leader>sW', '<cmd>FzfLua grep_visual cwd=false<cr>', mode = 'v', desc = 'Selection (cwd)' },
    { '<leader>uC', '<cmd>FzfLua colorschemes<cr>', desc = 'Colorscheme with Preview' },
    -- LSP navigation
    { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Go to Definition' },
    { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'References' },
    { 'gI', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Go to Implementation' },
    { 'gt', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Go to Type Definition' },
    { '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code Actions' },
    { '<leader>cs', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document Symbols' },
    { '<leader>cS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace Symbols' },
    { '<leader>cd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document Diagnostics' },
    { '<leader>cD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
    {
      '<leader>ss',
      function()
        require('fzf-lua').lsp_document_symbols {
          regex_filter = function(s)
            return s
          end,
        }
      end,
      desc = 'Goto Symbol',
    },
    {
      '<leader>sS',
      function()
        require('fzf-lua').lsp_live_workspace_symbols {
          regex_filter = function(s)
            return s
          end,
        }
      end,
      desc = 'Goto Symbol (Workspace)',
    },
  },
}
