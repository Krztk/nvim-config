local prettier = { "prettierd", "prettier" }

return {
    { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { prettier },
        typescript = { prettier },
        javascriptreact = { prettier },
        typescriptreact = { prettier },
        css = { prettier },
        html = { prettier },
        json = { prettier },
        jsonc = { prettier },
        yaml = { prettier },
        markdown = { prettier, "injected" },
        graphql = { prettier },
      },
    },
  },
}