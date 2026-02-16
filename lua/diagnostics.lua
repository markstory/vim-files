local nvim_lsp = require("lspconfig")


-- configure vim.diagnostics
vim.diagnostic.config({
  underline = true,
  signs = {
    text = {
      -- Gutter signs use devicons
      [vim.diagnostic.severity.ERROR] = '\u{F530}',
      [vim.diagnostic.severity.WARN] = '\u{f071}',
      [vim.diagnostic.severity.HINT] = '\u{f059}',
      [vim.diagnostic.severity.INFO] = '\u{f05a}',
    }
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    header = { '\u{F188} Diagnostics', 'Title' },
    source = 'always',
  },
  virtual_text = false,
})

local nvimlint = require('lint')

local file_exists = function(path)
  local exists = vim.fn.filereadable(path) == 1
  return exists
end

-- PHP linter config varies by project
local php_linters = {}
if file_exists('./vendor/bin/phpcs') then
  -- configure phpcs
  nvimlint.linters.phpcs.cmd = './vendor/bin/phpcs'
  table.insert(php_linters, 'phpcs')
end

-- Use either composer or phive tools for phpstan
if vim.fn.filereadable('./tools/phpstan') == 1 then
  nvimlint.linters.phpstan.cmd = './tools/phpstan'
  table.insert(php_linters, 'phpstan')
elseif vim.fn.filereadable('./vendor/bin/phpstan') == 1 then
  nvimlint.linters.phpstan.cmd = './vendor/bin/phpstan'
  table.insert(php_linters, 'phpstan')
end

-- Use eslint for js if it exists.
js_linters = {}
if vim.fn.filereadable('./node_modules/.bin/eslint') == 1 then
  table.insert(js_linters, 'eslint')
end

-- Configure linters for common toolchains
nvimlint.linters_by_ft = {
  javascript = js_linters,
  javascriptreact = js_linters,
  typescript = js_linters,
  typescriptreact = js_linters,
  python = {'ruff', 'mypy', },
  php = php_linters,
}

-- keymappings for diagnostics
local opts = {noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap

keymap('n', '<leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap('n', '[d', "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
keymap('n', ']d', "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

vim.api.nvim_create_autocmd({'BufWritePost'}, {
  callback = function()
    nvimlint.try_lint()
  end
})
