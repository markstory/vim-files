require('fzf-lua').setup({
  winopts = {
    height = 0.4,
    width = 0.93,
    row = 0.99,
    col = 0.3,
  },
  files = {
    cmd = "find -L . -type f",
    prompt = 'Files❯ ',
    multiprocess = true,
    file_icons = true,
    color_icons = true,
  }
})
