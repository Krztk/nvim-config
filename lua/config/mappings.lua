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

-- Copilot

vim.keymap.set("i", "<S-C-l>", "<Plug>(copilot-accept-line)")
vim.keymap.set("i", "<S-C-h>", "<Plug>(copilot-dismiss)")
vim.keymap.set("i", "<M-l>", "<Plug>(copilot-accept-word)")
vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-suggest)")
