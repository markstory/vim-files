require('fzf-lua').setup({
  height = 0.4,
  width = 0.85,
  row = 0.99,
  files = {
    cmd = "find -L . -type f",
  }
})
