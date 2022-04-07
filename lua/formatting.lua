-- Formatters
-- Not using diagnosticls for formatting as I couldn't figure out how to get it working.
-- formatter.nvim is simple and effective.
-- Formatting can be run via :Format
local formatter = require('formatter')

local eslint_fmt = {
  function()
    return {
      exe = "./node_modules/.bin/eslint",
      args = {"--fix", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
      stdin = false,
    }
  end
}

formatter.setup {
  logging = true,
  filetype = {
    typescript = eslint_fmt,
    typescriptreact = eslint_fmt,
    javascript = eslint_fmt,
    javascriptreact = eslint_fmt,
    python = {
      function ()
        return {
          exe = 'black',
          args = {"-"},
          stdin = true,
        }
      end,
      function ()
        return {
          exe = 'isort',
          args = {"-"},
          stdin = true,
        }
      end
    },
    php = {
      function ()
        return {
          exe = './vendor/bin/phpcbf',
          args = {'--stdin-path=' .. vim.api.nvim_buf_get_name(0), '-'},
          stdin = true,
          ignore_exitcode = true,
        }
      end
    }
  }
}
