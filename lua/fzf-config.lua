require('fzf-lua').setup({
  winopts = {
    height = 0.4,
    width = 0.93,
    row = 0.99,
    col = 0.3,
    backdrop = false,
  },
  files = {
    fzf_colors = true,
    find_opts = [[-type f -not -path '*.git/objects*' -not -path '*node_modules*' -not -path '*vendor*' -not -path '*.venv*' -not -path '*.env*' -not -path '*.pytest_cache*' -not -path '*.mypy_cache*' -not -path "*.devenv*"]],
    prompt = 'Files❯ ',
    multiprocess = true,
    file_icons = true,
    color_icons = true,
  },
  hls = {
    -- current buffer sigil
    buf_flag_cur = "Purple",
    -- buffer number id
    buf_nr = "Cyan",
    -- line numbers in buffer/path windows
    path_linenr = "Cyan",
    -- ctrl-x prompt
    header_bind = "Cyan",
    -- action binding takes
    header_text = "CursorLineNr",
  }
})
