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
vim.keymap.set("n", "<F6>", "<cmd>Neorg index<CR>", { desc = "[Neorg] index" })
vim.keymap.set("n", "<F7>", "<cmd>Neorg return<CR>", { desc = "[Neorg] return" })

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
