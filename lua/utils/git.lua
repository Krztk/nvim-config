local M = {}
local picker = require("snacks.picker")

function M.git_files_changed_in_x_commits(number_of_commits)
  if type(number_of_commits) ~= "number" then
    error("number_of_commits must be a number, got: " .. type(number_of_commits))
  end

  if number_of_commits < 1 then
    error("number_of_commits must be >= 1, got: " .. number_of_commits)
  end

  local git_cmd = "git diff --diff-filter=d --name-status HEAD~" .. number_of_commits .. "..HEAD"

  -- Execute command
  local handle = io.popen(git_cmd)
  if not handle then
    error("Failed to execute git command: " .. git_cmd)
  end

  local result = handle:read("*a")
  local success, exit_code = handle:close()

  if not success then
    error("Git command failed with exit code: " .. (exit_code or "unknown"))
  end

  local files = {}
  if result and result ~= "" then
    for line in result:gmatch("[^\r\n]+") do
      -- Try to match rename first
      local status, file1, file2 = line:match("^(R%d+)%s+(.+)%s+(.+)$")
      if not status then
        -- Otherwise match normal status (M, A, R__)
        status, file1 = line:match("^(%S+)%s+(.+)$")
      end
      if file2 then
        table.insert(files, { status = status, file = file2 })
      else
        table.insert(files, { status = status, file = file1 })
      end
    end
  end

  return files
end

function M.changed_files_in_last_x_commits_picker(number_of_commits)
  local items = M.git_files_changed_in_x_commits(number_of_commits)
  local finder_items = {}

  for _, item in ipairs(items) do
    local text = item.file
    table.insert(finder_items, {
      text = text,
      item = item,
      file = item.file,
    })
  end

  picker.pick({
    items = finder_items,
    format = function(item)
      return { {
        item.text,
      } }
    end,
    title = "Changed in last " .. number_of_commits .. " commits",
  })
end

return M
