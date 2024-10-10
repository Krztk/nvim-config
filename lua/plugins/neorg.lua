return {
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*", -- Pin Neorg to the latest stable release
		config = true,
		-- options for neorg. This will automatically call `require("neorg").setup(opts)`
		opts = {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {}, --icons
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/notes",
						},
						default_workspace = "notes",
					},
				},
			},
		},
	},
}
