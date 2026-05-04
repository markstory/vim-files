-- Install packages that my config relies on.
vim.pack.add({
  'https://github.com/tpope/vim-ragtag',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-unimpaired',
  'https://github.com/Townk/vim-autoclose',

  'https://github.com/duff/vim-scratch',
  'https://github.com/markstory/vim-zoomwin',
  -- Project Drawer
  {src = 'https://github.com/lambdalisue/fern.vim', version = 'main'},
  'https://github.com/lambdalisue/nerdfont.vim',
  'https://github.com/lambdalisue/fern-renderer-nerdfont.vim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  -- Search and find
  'https://github.com/mileszs/ack.vim',
  {src = 'https://github.com/ibhagwan/fzf-lua', version= 'main'},

  -- Commenting, Git and Wiki
  'https://github.com/ddollar/nerdcommenter',
  'https://github.com/tpope/vim-git',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/vimwiki/vimwiki',

  -- Languages
  'https://github.com/timcharper/textile.vim',
  'https://github.com/groenewege/vim-less',
  'https://github.com/tpope/vim-markdown',
  'https://github.com/mustache/vim-mustache-handlebars',
  'https://github.com/mitsuhiko/vim-jinja',
  'https://github.com/nvim-lua/plenary.nvim',
  {src = 'https://github.com/akinsho/flutter-tools.nvim', version = 'main'},

  -- Improved syntax highlighting
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  {src = 'https://github.com/hrsh7th/cmp-nvim-lsp', version = 'main'},
  {src = 'https://github.com/hrsh7th/cmp-buffer', version = 'main'},
  {src = 'https://github.com/hrsh7th/cmp-path', version = 'main'},
  {src = 'https://github.com/hrsh7th/cmp-cmdline', version = 'main'},
  {src = 'https://github.com/hrsh7th/nvim-cmp', version = 'main'},
  {src = 'https://github.com/hrsh7th/cmp-vsnip', version = 'main'},
  'https://github.com/hrsh7th/vim-vsnip',

  -- Formatting & Linting
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/mhartington/formatter.nvim',
  'https://github.com/editorconfig/editorconfig-vim',

  -- Statusline
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Theme
  'https://github.com/sainnhe/edge',
})
