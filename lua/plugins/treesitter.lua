return {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
	highlight = { enable = true },
        indent = { enable = true },
    }
  end
}
