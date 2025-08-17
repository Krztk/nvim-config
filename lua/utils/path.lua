local M = {}

function M.get_project_root()
	-- Try to find git root first
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		return git_root
	end
	-- Fallback to current working directory
	return vim.fn.getcwd()
end

return M
