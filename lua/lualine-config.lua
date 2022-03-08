
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
    theme = 'edge',
    section_separators = {'\u{E0B4}', '\u{E0B6}'},
    component_separators = {'\u{E0B5}', '\u{E0B7}'},
  },
  extensions = {'fugitive', 'fern'},
  sections = {
    lualine_a = {short_mode},
    lualine_b = {
      {
        'branch',
        icon = '\u{F126}',
      }
    },
    lualine_c = {
      {
        'diff',
        colored = true,
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
      },
      {
        'fileformat',
      },
      {
        'filetype',
      }
    },
    lualine_y = {
      {
        'progress',
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {'filename', path = 1},
    },
  },
})
