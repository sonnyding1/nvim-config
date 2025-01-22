-- Helper function to run shell commands
local function run_git_command(args, directory)
  local uv = vim.loop
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)

  local handle
  handle = uv.spawn("git", {
    args = args,
    stdio = { nil, stdout, stderr },
    cwd = directory,
  }, function(code, signal)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print("Git " .. table.concat(args, " ") .. " failed with code " .. code .. " and signal " .. signal)
    end
  end)

  local outdata = ""
  stdout:read_start(function(err, data)
    assert(not err, err)
    if data then
      outdata = outdata .. data
    else
      if outdata ~= "" then
        print("Output: " .. outdata)
      end
    end
  end)

  local errdata = ""
  stderr:read_start(function(err, data)
    assert(not err, err)
    if data then
      errdata = errdata .. data
    else
      if errdata ~= "" then
        print("Error: " .. errdata)
      end
    end
  end)
end

-- Function to commit changes with the current timestamp
local function commit_and_push()
  -- Get the current time as a string
  local current_time = os.date("%Y-%m-%d %H:%M:%S")

  -- Add all changes
  run_git_command({ "add", "." }, "~/diary")
  print("git add done")

  -- Commit changes with a message
  run_git_command({ "commit", "-m", "sync " .. current_time }, "~/diary")

  -- Push changes
  run_git_command({ "push" }, "~/diary")
end

-- Set up autocommand for `BufEnter` to perform git pull
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "/root/diary/*",
  callback = function()
    print("hello i just entered")
    run_git_command({ "pull" }, "/root/diary")
  end,
})

-- Set up autocommand for `BufLeave` to perform add, commit, and push
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "~/diary/*",
  callback = function()
    commit_and_push()
  end,
})
