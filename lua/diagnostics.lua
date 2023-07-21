local nvim_lsp = require("lspconfig")

-- Gutter signs and highlights
local signs = {
  Error = '\u{F0159}',
  Warn = '\u{F071}',
  Hint = '\u{F0335}',
  Info = '\u{F05A}',
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ''})
end

-- configure vim.diagnostics
vim.diagnostic.config({
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    header = { '\u{F188} Diagnostics', 'Title' },
    source = 'always',
  },
  virtual_text = false,
})


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
    rootPatterns = {"composer.lock", "vendor"},
    args = {"--report=json", "--stdin-path=%filepath", "-s", "-"},
    sourceName = "phpcs",
    parseJson = {
      errorsRoot =  'files.["%filepath"].messages',
      line = 'line',
      column = 'column',
      endLine = 'line',
      endColumn = 'column',
      message = '[phpcs] ${message} [${source}]',
      security = 'type',
    },
    securities = {
      error = "ERROR",
      warning = "WARNING",
    },
    requiredFiles = {"vendor/bin/phpcs"}
  },
  psalm = {
    command = "vendor/bin/psalm.phar",
    sourceName = "psalm",
    debounce = 100,
    rootPatterns = {"composer.lock", "vendor", ".git"},
    args = {"--output-format=emacs", "--no-progress"},
    offsetLine = 0,
    offsetColumn = 0,
    sourceName = "psalm",
    formatLines = 1,
    formatPattern = {
      '^(.*):(\\d+):(\\d+):(.*)\\s-\\s(.*)$',
      {
        sourceName = 1,
        sourceNameFilter = true,
        line = 2,
        column = 3,
        message = 5,
        security = 4
      }
    },
    securities = {
      error = "error",
      warning = "warning"
    },
    requiredFiles = {"vendor/bin/psalm.phar"}
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
