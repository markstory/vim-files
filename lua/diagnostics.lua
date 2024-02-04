local nvim_lsp = require("lspconfig")

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

-- Use either composer or phive tools.
if vim.fn.filereadable('./tools/psalm') == 1 then
  nvimlint.linters.psalm.cmd = './tools/psalm'
  table.insert(php_linters, 'psalm')
elseif vim.fn.filereadable('./vendor/bin/psalm') == 1 then
  nvimlint.linters.psalm.cmd = './vendor/bin/psalm'
  table.insert(php_linters, 'psalm')
end

-- Some projects use eslint, others use biome
js_linters = {}
if vim.fn.filereadable('./node_modules/.bin/eslint') == 1 then
  table.insert(js_linters, 'eslint')
end
if vim.fn.filereadable('./node_modules/.bin/biome') == 1 then
  table.insert(js_linters, 'biomejs')
end

-- Configure linters for common toolchains
nvimlint.linters_by_ft = {
  javascript = js_linters,
  javascriptreact = js_linters,
  typescript = js_linters,
  typescriptreact = js_linters,
  python = {'flake8', 'mypy', },
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
