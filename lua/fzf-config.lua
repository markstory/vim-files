require('fzf-lua').setup({
  winopts = {
    height = 0.4,
    width = 0.93,
    row = 0.99,
    col = 0.3,
  },
  files = {
    cmd = "find -L .",
    find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -not -path 'vendor/*']],
    prompt = 'Files❯ ',
    multiprocess = true,
    file_icons = true,
    color_icons = true,
  }
})
