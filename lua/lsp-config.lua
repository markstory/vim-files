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
    nvim_lsp = true;
    nvim_lua = true;
  }
}

-- short cut methods.
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
-- Close completion if the last char is .
local check_back_space = function ()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Global function used to send <C-n> to compe
-- if it is open, tab if it is closed, and compe refresh
-- if we're at a break.
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

-- Handler to attach LSP keymappings to buffers using LSP.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

  --- Mappings
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gh', "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>", opts)
  buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)

  -- scroll down in popups
  buf_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)

  -- Navigate and preview
  buf_set_keymap('n', 'gs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
  buf_set_keymap('n', 'gd', "<cmd>lua require('lspsaga.provider').preview_definition()<CR>", opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)

  -- View diagnostics
  buf_set_keymap('n', '<space>e', "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '[d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>", opts)
  buf_set_keymap('n', ']d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>", opts)

  -- Autocomplete
  buf_set_keymap("i", "<C-Space>", 'compe#complete()', {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<Esc>", "compe#close('<Esc>')", {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
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
  php = {"phpcs", "psalm"},
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
    sourceName = "phpcs",
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
    requiredFiles = {"vendor/bin/phpcs"}
  },
  psalm = {
    command = "./vendor/bin/psalm",
    sourceName = "psalm",
    debounce = 100,
    rootPatterns = {"composer.lock", "vendor", ".git"},
    args = {"--output-format=emacs", "--no-progress"},
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "psalm",
    formatLines = 1,
    formatPattern = {
      "^[^ =]+ =(\\d+) =(\\d+) =(.*)\\s-\\s(.*)(\\r|\\n)*$",
      {
        line = 1,
        column = 2,
        message = 4,
        security = 3
      }
    },
    securities = {
      error = "error",
      warning = "warning"
    },
    requiredFiles = {"vendor/bin/psalm"}
  }
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = vim.tbl_keys(filetypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
  },
}

saga.init_lsp_saga {
  error_sign = '\u{F658}',
  warn_sign = '\u{F071}',
  hint_sign = '\u{F835}',
}
