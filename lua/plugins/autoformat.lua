local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 2000,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = prettier,
				typescript = prettier,
				javascriptreact = prettier,
				typescriptreact = prettier,
				css = prettier,
				html = prettier,
				json = prettier,
				jsonc = prettier,
				yaml = prettier,
				markdown = { "prettierd", "prettier", "injected", stop_after_first = true },
				graphql = prettier,
			},
		},
	},
}
