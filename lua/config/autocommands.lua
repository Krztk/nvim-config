vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("auto-command-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

