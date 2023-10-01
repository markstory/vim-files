require('fzf-lua').setup({
  winopts = {
    height = 0.4,
    width = 0.93,
    row = 0.99,
    col = 0.3,
  },
  files = {
    find_opts = [[-type f -not -path '*.git/objects*' -not -path '*node_modules*' -not -path '*vendor*' -not -path '*.venv*' -not -path '*.env*' -not -path '*.pytest_cache*' -not -path '*.mypy_cache*']],
    prompt = 'Files❯ ',
    multiprocess = true,
    file_icons = true,
    color_icons = true,
  }
})
