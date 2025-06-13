vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>x", [["_d]])
vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<F5>", function()
	local initFilePath = vim.fn.stdpath("config") .. "/init.lua"
	print(initFilePath)
	vim.cmd("e " .. initFilePath)
end, { desc = "Open config file" })

vim.keymap.set("n", "<leader>b", "<cmd>lua MiniFiles.open()<CR>", { desc = "[Mini.files] Find Files" })

-- lua
vim.keymap.set("n", "<leader>ts", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>tl", ":.lua<CR>")
vim.keymap.set("v", "<leader>tl", ":lua<CR>")

-- quickfix
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- format range
vim.keymap.set("", "<leader>dc", function()
	require("conform").format({ async = true }, function(err)
		if not err then
			local mode = vim.api.nvim_get_mode().mode
			if vim.startswith(string.lower(mode), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
			end
		end
	end)
end, { desc = "Format code" })

-- terminal
vim.keymap.set("t", "<C-k><C-j>", [[<C-\><C-n>]], { noremap = true, silent = true })

--diff
local function toggle_diffview(cmd)
	if next(require("diffview.lib").views) == nil then
		vim.cmd(cmd)
	else
		vim.cmd("DiffviewClose")
	end
end

vim.keymap.set("n", "<leader>dvi", function()
	toggle_diffview("DiffviewOpen")
end, { desc = "Diff Index", noremap = true, silent = true })
vim.keymap.set("n", "<leader>dvm", function()
	toggle_diffview("DiffviewOpen master..HEAD")
end, { desc = "Diff Master", noremap = true, silent = true })
vim.keymap.set("n", "<leader>dvf", function()
	toggle_diffview("DiffviewFileHistory %")
end, { desc = "Current file diff", noremap = true, silent = true })

local diff_opts = {
	"filler,internal,closeoff,algorithm:histogram,context:3,linematch:60",
	"internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram,context:3",
}

local current_diff_opt = 1

local function toggle_diffopt()
	current_diff_opt = (current_diff_opt % #diff_opts) + 1
	vim.opt.diffopt = diff_opts[current_diff_opt]
	print("Diffopt set to: " .. diff_opts[current_diff_opt])
end

vim.keymap.set("n", "<leader>td", toggle_diffopt, { desc = "Toggle diff strategy" })

local status_ok, _ = pcall(require, "config.mappings_local")
if not status_ok then
	vim.notify(
		"[mappings.lua] Skipping private mappings: 'config/mappings_local.lua' not available.",
		vim.log.levels.INFO
	)
end

-- markdown navigation
local function get_project_root()
	-- Try to find git root first
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		return git_root
	end
	-- Fallback to current working directory
	return vim.fn.getcwd()
end

local function normalize_path(path)
	-- Convert forward slashes to appropriate separator for the OS
	if vim.fn.has("win32") == 1 then
		return path:gsub("/", "\\")
	end
	return path
end

local function resolve_filepath(link_path, current_file_dir)
	local filepath

	if link_path:match("^/") then
		-- Absolute path from project root
		local project_root = get_project_root()
		filepath = vim.fn.resolve(project_root .. link_path)
	elseif link_path:match("^%./") then
		-- Relative to current file's directory
		filepath = vim.fn.resolve(current_file_dir .. "/" .. link_path:sub(3))
	else
		-- No prefix = relative to current file's directory
		filepath = vim.fn.resolve(current_file_dir .. "/" .. link_path)
	end

	return normalize_path(filepath)
end

local function follow_markdown_link()
	local line = vim.api.nvim_get_current_line()

	-- Extract filename from [[path/filename]] or [text](path/filename.md)
	local wiki_link = line:match("%[%[([^%]]+)%]%]")
	local md_link = line:match("%[.-%]%(([^%)]+)%)")
	local link_path = wiki_link or md_link

	if link_path then
		local current_file = vim.api.nvim_buf_get_name(0)
		local current_file_dir = vim.fn.fnamemodify(current_file, ":h")

		-- Handle wiki-style links - add .md if no extension
		if wiki_link and not link_path:match("%.%w+$") then
			link_path = link_path .. ".md"
		end

		local filepath = resolve_filepath(link_path, current_file_dir)

		local success, err = pcall(function()
			vim.cmd("edit " .. vim.fn.fnameescape(filepath))
		end)

		if not success then
			print("Could not open file: " .. filepath)
			-- vim.fn.mkdir(vim.fn.fnamemodify(filepath, ":h"), "p")
			-- vim.cmd("edit " .. vim.fn.fnameescape(filepath))
		end
	else
		-- No link found, just send Enter key
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<CR>", follow_markdown_link, {
			buffer = true,
			desc = "Follow markdown link",
		})
	end,
})
