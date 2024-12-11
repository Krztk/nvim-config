local session_folder = vim.fn.stdpath("config") .. "/sessions/"

local handle_session_selection = function()
	local session_files = vim.fn.glob(session_folder .. "*.vim", false, true)

	local match_filename_windows = "^.+\\(.+)$"
	local match_filename_linux = "^.+/(.+)$"
	local match_filename_str = match_filename_linux

	if vim.loop.os_uname().sysname == "Windows_NT" then
		match_filename_str = match_filename_windows
	end

	vim.ui.select(session_files, {
		prompt = "Select a session",
		format_item = function(item)
			return item:match(match_filename_str)
		end,
	}, function(choice)
		if choice ~= nil then
			vim.cmd("source " .. choice)
		end
	end)
end

vim.api.nvim_create_user_command("SessionSave", function(opts)
	vim.cmd("mksession! " .. session_folder .. opts.fargs[1] .. ".vim")
	print("Session saved")
end, { nargs = 1 })

vim.api.nvim_create_user_command("SessionLoad", function()
	handle_session_selection()
end, {
	nargs = 0,
})

vim.api.nvim_create_user_command("PathSet", function()
	vim.cmd("cd %:p:h")
end, { nargs = 0 })

local function edit_neovim()
	require("telescope.builtin").git_files({
		shorten_path = false,
		cwd = vim.fn.stdpath("config"),
		prompt = "~ dotfiles ~",
		height = 10,

		layout_strategy = "horizontal",
		layout_options = {
			preview_width = 0.75,
		},
	})
end

vim.api.nvim_create_user_command("Config", edit_neovim, { nargs = 0 })

vim.api.nvim_create_user_command("FontSize", function(opts)
	vim.o.guifont = "LiterationMono Nerd Font:h" .. opts.fargs[1]
end, { nargs = 1 })

function ToggleVirtualText()
	-- Fetch the current configuration
	local current_config = vim.diagnostic.config()

	-- Toggle the virtual_text setting by negating the current value
	vim.diagnostic.config({
		virtual_text = not current_config.virtual_text,
	})

	print("Virtual Text: " .. (not current_config.virtual_text and "Enabled" or "Disabled"))
end

vim.api.nvim_set_keymap("n", "<leader>tv", ":lua ToggleVirtualText()<CR>", { noremap = true, silent = true })

function GetFileRelativePath()
	local filepath = vim.fn.expand("%:p")
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	if vim.v.shell_error ~= 0 then
		print("Not in a git repository")
		return
	end

	local relative_path = filepath:sub(#git_root + 2)
	vim.fn.setreg("+", relative_path)
	print("Copied relative path: " .. relative_path)
	return relative_path
end

vim.keymap.set(
	"n",
	"<leader>dp",
	GetFileRelativePath,
	{ noremap = true, silent = true, desc = "Get '[D]ocument' relative [p]ath" }
)
