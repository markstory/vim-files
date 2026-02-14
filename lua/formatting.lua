-- Formatters
-- Not using diagnosticls for formatting as I couldn't figure out how to get it working.
-- formatter.nvim is simple and effective.
-- Formatting can be run via :Format
local formatter = require('formatter')

local js_fmt = {
  function()
    return {
      exe = "./node_modules/.bin/eslint",
      args = {"--fix", vim.api.nvim_buf_get_name(0)},
      ignore_exitcode = true,
    }
  end
}

formatter.setup {
  filetype = {
    typescript = js_fmt,
    typescriptreact = js_fmt,
    javascript = js_fmt,
    javascriptreact = js_fmt,
    python = {
      function ()
        return {
          exe = 'uv run ruff',
          args = {"format", "-q", "-"},
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
    },
    dart = {
      function ()
        return {
          exe = 'flutter format',
          args = {vim.api.nvim_buf_get_name(0), '-l', '120'},
          stdin = false,
          ignore_exitcode = true,
        }
      end
    },
    rust = {
      function ()
        return {
          exe = 'cargo fmt',
          args = {'--', vim.api.nvim_buf_get_name(0)},
          stdin = false,
          ignore_exitcode = true,
        }
      end
    },
  }
}
