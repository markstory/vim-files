-- lualine onelight theme.
local colors = {
  blue   = '#0184bc',
  green  = '#50a14f',
  purple = '#a626a4',
  red   = '#ca1243',
  yellow = '#c18401',
  fg     = '#090a0b',
  bg     = '#fafafa',
  gray100  = '#f0f0f1',
  gray200  = '#e5e5e6',
  gray300  = '#a0a1a7',
  gray400 = '#696c77',
}

onelight_theme = {
  normal = {
    a = {fg = colors.bg, bg = colors.green, gui = 'bold'},
    b = {fg = colors.fg, bg = colors.gray200},
    c = {fg = colors.fg, bg = colors.gray100}
  },
  insert = {a = {fg = colors.bg, bg = colors.blue, gui = 'bold'}},
  visual = {a = {fg = colors.bg, bg = colors.purple, gui = 'bold'}},
  replace = {a = {fg = colors.bg, bg = colors.red, gui = 'bold'}},
  inactive = {
    a = {fg = colors.gray400, bg = colors.gray100, gui = 'bold'},
    b = {fg = colors.gray400, bg = colors.gray100},
    c = {fg = colors.gray400, bg = colors.gray100}
  }
}

light_muted = {
  fg = colors.gray400,
  bg = colors.gray100,
}
medium_muted = {
  fg = colors.gray400,
  bg = colors.gray200,
}

-- Custom mode map with short names.
local get_mode = require('lualine.utils.mode').get_mode
local short_map = {
  ['NORMAL'] = 'N',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['REPLACE'] = 'R',
}
local function short_mode()
  local mode = get_mode()
  if short_map[mode] == nil then return mode end
  return short_map[mode]
end

require('lualine').setup({
  options = {
    theme = onelight_theme,
    section_separators = {'\u{E0B4}', '\u{E0B6}'},
    component_separators = {'\u{E0B5}', '\u{E0B7}'},
  },
  extensions = {'fugitive', 'fern'},
  sections = {
    lualine_a = {short_mode},
    lualine_b = {
      {
        'branch',
        color = medium_muted,
        icon = '\u{F126}',
      }
    },
    lualine_c = {
      {
        'diff',
        colored = true,
        color = light_muted,
        separator = '\u{E0B7}',
      },
      {
        'filename',
        file_status = true,
        path = 1,
      },
    },
    lualine_x = {
      {
        'encoding',
        color = light_muted,
      },
      {
        'fileformat',
        color = light_muted,
      },
      {
        'filetype',
        color = light_muted,
      }
    },
    lualine_y = {
      {
        'progress',
        color = medium_muted,
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {'filename', path = 1},
    },
  },
})
