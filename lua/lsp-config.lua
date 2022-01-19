local nvim_lsp = require("lspconfig")

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

  -- Hover
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- code actions
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)

  -- Navigate and preview
  --buf_set_keymap('n', 'gd', "<cmd>lua require('lspsaga.provider').preview_definition()<CR>", opts)
  buf_set_keymap('n', 'gs', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  -- View diagnostics
  buf_set_keymap('n', '<space>e', "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  --buf_set_keymap('n', '[d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>", opts)
  --buf_set_keymap('n', ']d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>", opts)

  -- Autocomplete
  buf_set_keymap("i", "<C-Space>", 'compe#complete()', {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<Esc>", "compe#close('<Esc>')", {noremap = true, silent = true, expr = true})
  buf_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
end

-- Make floating windows have rounded borders. (doesn't work yet)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

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
