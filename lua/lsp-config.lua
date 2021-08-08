--- Configuration for LSP, formatters, and linters.
local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")

-- Completion setup
local compe = require("compe")

vim.o.completeopt = "menuone,noselect"

compe.setup {
  enabled = true;
  autocomplete = true;
  throttle_time = 200;
  source_timeout = 150;
  source = {
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
  }
}

-- Handler to attach LSP keymappings to buffers using LSP.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

  --- Local commands
  -- Apply LSP formatting fixes
  vim.cmd("command! Fix lua vim.lsp.buf.formatting()")

  --- Mappings
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gh', "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>", opts)
  buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)

  -- scroll down in popups
  buf_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)

  -- Navigate and preview
  buf_set_keymap('n', 'gs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
  buf_set_keymap('n', 'gd', "<cmd>lua require('lspsaga.provider').preview_definition()<CR>", opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  -- View diagnostics
  buf_set_keymap('n', '<space>e', "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '[d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>", opts)
  buf_set_keymap('n', ']d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>", opts)

  -- Autocomplete
  buf_set_keymap("i", "<C-Space>", 'compe#complete()', {noremap=true, silent=true, expr=true})
  buf_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {noremap=true, silent=true, expr=true})
  buf_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {noremap=true, silent=true, expr=true})
end

-- Typescript
nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    -- Disable tsserver formatting as prettier/eslint does that.
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end
}
-- Python
nvim_lsp.pyright.setup {
  on_attach = on_attach,
}
-- PHP
nvim_lsp.intelephense.setup {
  on_attach = on_attach,
}


--- Linter setup
local filetypes = {
  typescript = "eslint",
  typescriptreact = "eslint",
  python = "flake8",
  php = "phpcs",
}

local linters = {
  eslint = {
    sourceName = "eslint",
    command = "./node_modules/.bin/eslint",
    rootPatterns = {".eslintrc.js", "package.json"},
    debouce = 100,
    args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
    parseJson = {
      errorsRoot = "[0].messages",
      line = "line",
      column = "column",
      endLine = "endLine",
      endColumn = "endColumn",
      message = "${message} [${ruleId}]",
      security = "severity"
    },
    securities = {[2] = "error", [1] = "warning"}
  },
  flake8 = {
    command = "flake8",
    sourceName = "flake8",
    args = {"--format", "%(row)d:%(col)d:%(code)s: %(text)s", "%file"},
    formatPattern = {
      "^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
      {
          line = 1,
          column = 2,
          message = {"[", 3, "] ", 5},
          security = 4
      }
    },
    securities = {
      E = "error",
      W = "warning",
      F = "info",
      B = "hint",
    },
  },
  phpcs = {
    command = "vendor/bin/phpcs",
    debounce = 300,
    rootPatterns = {"composer.lock", "vendor", ".git"},
    args = {"--report=emacs", "-s", "-"},
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "phpcs",
    formatLines = 1,
    formatPattern = {
      "^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$",
      {
        line = 1,
        column = 2,
        message = 4,
        security = 3
      }
    },
    securities = {
      error = "error",
      warning = "warning",
    },
  },
}

nvim_lsp.diagnosticls.setup {
  on_attach = custom_attach,
  filetypes = vim.tbl_keys(filetypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
  },
}

saga.init_lsp_saga()
