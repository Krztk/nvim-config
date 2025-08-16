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
					local files = require("lua.utils.git").git_files_changed_in_x_commits(1)

					local picker_files = {}
					for _, v in pairs(files) do
						table.insert(
							picker_files,
							{ text = "[" .. v.status .. "] " .. v.file, info = v.status, file = v.file }
						)
					end

					Snacks.picker.pick({
						items = picker_files,
						format = function(item, picker)
							return { { item.text } }
						end,
					})
				end,
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
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
				desc = "Git diff",
			},
		},
	},
}
