local session_folder = vim.fn.stdpath("config") .. "/sessions/"

local function get_session_files()
	return vim.split(vim.fn.glob(session_folder .. "*.vim"), "\n", { trimempty = true })
end

vim.api.nvim_create_user_command("SessionSave", function(opts)
	vim.cmd("mksession " .. session_folder .. opts.fargs[1] .. ".vim")
	print("Session saved")
end, { nargs = 1 })

vim.api.nvim_create_user_command("SessionLoad", function(opts)
	vim.cmd("source " .. opts.fargs[1])
	print("Session loaded " .. opts.fargs[1])
end, {
	nargs = 1,
	complete = function(ArgLead, CmdLine, CursorPos)
		return get_session_files()
	end,
})
