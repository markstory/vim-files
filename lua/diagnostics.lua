-- Gutter signs and highlights
local signs = {
  Error = '\u{F530}',
  Warn = '\u{f071}',
  Hint = '\u{f059}',
  Info = '\u{f05a}',
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ''})
end

-- configure formatting for vim.diagnostics
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

-- Configure null-ls wrappers around vim.diagnostics
-- tool configuration.
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- linters
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.mypy,

    null_ls.builtins.diagnostics.eslint.with({
      command = './node_modules/.bin/eslint',
    }),

    null_ls.builtins.diagnostics.phpcs.with({
      command = './vendor/bin/phpcs',
    }),
    null_ls.builtins.diagnostics.psalm.with({
      command = './tools/psalm',
    }),

    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,

    null_ls.builtins.formatting.eslint.with({
      command = './node_modules/.bin/eslint',
    }),

    null_ls.builtins.formatting.phpcbf.with({
      command = './vendor/bin/phpcbf',
    }),

    null_ls.builtins.formatting.dart_fmt,
  }
})
