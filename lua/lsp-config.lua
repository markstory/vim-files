local nvim_lsp = require("lspconfig")

-- Completion setup
local cmp = require("cmp")

vim.o.completeopt = "menu,menuone,noselect"

-- Nerdfont icons for autocomplete.
local kind_icons = {
  Class = "ﴯ",
  Color = "",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰇼",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Keyword = "",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Property = "ﰠ",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "󰅲",
  Unit = "",
  Value = "󰎠",
  Variable = "󰂡",
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {
    -- no automatic autocomplete. Manually trigger with C-space
    autocomplete = false,
  },
  formatting = {
    format = function (entry, vim_item)
      -- format the trailing symbol and kind name.
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        nvim_lua = "[Lua]",
      })[entry.source_name]
      return vim_item
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` 
    -- to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- `/` and `:` cmdline setup
cmp.setup.cmdline('/', {
  -- tab to start/select and Ctrl-y to select
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  -- tab to start/select and Ctrl-y to select
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- short cut methods.
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Definition peek
local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end
_G.lsp_peek_definition = function()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

-- Handler to attach LSP keymappings to buffers using LSP.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Hover
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- code actions
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)

  -- Navigate and preview
  buf_set_keymap('n', 'gd', "<cmd>lua lsp_peek_definition()<CR>", opts)
  buf_set_keymap('n', 'gs', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gr', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- flutter tools (lsp and command configuration)
require("flutter-tools").setup({
  lsp = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
})

-- Typescript
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable tsserver formatting as prettier/eslint does that.
    client.server_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end
}
-- PHP
nvim_lsp.intelephense.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}
-- python
nvim_lsp.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}
-- rust
nvim_lsp.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}


-- Make all LSP windows have consistent borders.
local border = {
    {'\u{250C}', "FloatBorder"},
    {"\u{2500}", "FloatBorder"},
    {"\u{2510}", "FloatBorder"},
    {"\u{2502}", "FloatBorder"},
    {"\u{2518}", "FloatBorder"},
    {"\u{2500}", "FloatBorder"},
    {"\u{2514}", "FloatBorder"},
    {"\u{2502}", "FloatBorder"},
}
local orig_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_floating_preview(contents, syntax, opts, ...)
end
