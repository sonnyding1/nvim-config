return {
  "CRAG666/code_runner.nvim",
  config = function()
    require("code_runner").setup({
      filetype = {
        python = {
          "cd $dir &&",
          "python3 -u $fileName",
        },
      },
    })
  end,
}
