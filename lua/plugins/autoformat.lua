local prettier = { "eslint_d", "prettierd", stop_after_first = false }

return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			-- format_on_save = {
			-- 	timeout_ms = 4000,
			-- 	lsp_fallback = true,
			-- },
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 4000, lsp_format = true }
			end,

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
				markdown = { "prettierd", "injected", stop_after_first = true },
				graphql = prettier,
			},
		},
	},
}
