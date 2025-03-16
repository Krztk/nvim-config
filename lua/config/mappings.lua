vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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

vim.keymap.set("n", "<leader>ttd", "<cmd>colorscheme tokyonight-day<CR>")

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
