-- Colors and cursors

-- Default color scheme
vim.g.noshowmode = true
vim.g.termguicolors = true

-- Theme
--vim.cmd[[color base16_one_light]]
vim.g.tokyonight_style = "day"
vim.g.tokyonight_day_brightness = 0.3
--vim.g.tokyonight_transparent = 1
vim.g.tokyonight_lualine_bold = 1
vim.g.tokyonight_sidebars = { "fern" }
--vim.g.tokyonight_dark_sidebar = true

vim.cmd[[colorscheme tokyonight]]
