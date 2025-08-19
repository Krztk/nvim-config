return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			picker = { enabled = true },
		},
		keys = {
			{
				"<leader>sc",
				function()
					require("utils.git").changed_files_in_last_x_commits_picker(1)
				end,
				desc = "Changed files in the last commit",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>sf",
				function()
					Snacks.picker.files()
				end,
				desc = "Files",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git status",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git diff",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help",
			},
		},
	},
}
