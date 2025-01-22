vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", ":Oil<CR>")

vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { noremap = true, silent = false })

-- telescope
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fc", function()
  builtin.find_files({ cwd = utils.buffer_dir() })
end, { desc = "Telescope find files in cwd" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- aoc only
vim.keymap.set("n", "<leader>s", function()
  -- Extract year, day, and part from the file path
  local filepath = vim.fn.expand("%:p")
  local parts = vim.split(filepath, "/")
  local year = parts[#parts - 3]
  local day = parts[#parts - 2]
  local part = parts[#parts - 1]
  local dir = table.concat(parts, "/", 1, #parts - 1)
  print(vim.inspect(parts))

  vim.cmd("lcd " .. dir)

  -- Build the command
  local cmd = string.format("!aoc s -y %s -d %s %s ", year, day, part)

  -- Prompt for the answer
  local ans = vim.fn.input("Answer: ")
  vim.cmd(cmd .. ans)
end, { silent = true, desc = "Submit AoC Solution" })

vim.keymap.set("n", "<leader>d", function()
  -- Extract year, day, and part from the file path
  local filepath = require("oil").get_current_dir()
  local parts = vim.split(filepath, "/")
  local year = parts[#parts - 3]
  local day = parts[#parts - 2]
  local dir = table.concat(parts, "/", 1, #parts - 1)

  vim.cmd("lcd " .. dir)

  -- Build the command
  local cmd = string.format("!aoc d -y %s -d %s ", year, day)

  vim.cmd(cmd)
end, { silent = true, desc = "Download AoC Descripton and Input" })
