return {
  "mhartington/formatter.nvim",
  config = function()
    local util = require("formatter.util")

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        python = {
          require("formatter.filetypes.python").black,
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
          function()
            return {
              exe = "stylua",
              args = {
                "--search-parent-directories",
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--indent-type",
                "Spaces",
                "--indent-width",
                2,
                "--",
                "-",
              },
              stdin = true,
            }
          end,
        },
        json = {
          require("formatter.filetypes.json").jq,
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    })

    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    augroup("__formatter__", { clear = true })
    autocmd("BufWritePost", {
      group = "__formatter__",
      command = ":FormatWrite",
    })
  end,
}
