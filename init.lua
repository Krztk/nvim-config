-- vim.deprecate = function() end
--
require("config.options")
require("config.neovide")
require("config.commands")
require("config.mappings")
require("config.lists")
require("config.autocommands")

vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-mini/mini.files",
  "https://github.com/nvim-mini/mini.comment",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/Krztk/vim-slash",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/Issafalcon/lsp-overloads.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/seblyng/roslyn.nvim",
})

vim.cmd.colorscheme("tokyonight-night")
local minifiles = require("mini.files")
minifiles.setup()
require("mini.comment").setup()
require("mini.surround").setup()

vim.keymap.set("n", "<leader>fe", minifiles.open, { desc = "MiniFiles open" })
vim.keymap.set("n", "<leader>fE", function()
  if vim.fn.filereadable(vim.fn.bufname("%")) > 0 then
    minifiles.open(vim.api.nvim_buf_get_name(0))
    minifiles.reveal_cwd()
  else
    minifiles.open()
  end
end, { desc = "mini.files open current" })

-- pickers

local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Files" })
vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>ss", fzf.git_status, { desc = "Git status" })

-- formatting

local prettier = { "eslint_d", "prettierd", stop_after_first = false }

require("conform").setup({
  notify_on_error = false,
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
})

-- lsp

require("mason").setup()

local ui_options = {
  border = "rounded",
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-plugin-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", fzf.lsp_definitions, "[G]oto [D]efinition")
    map("gr", fzf.lsp_references, "[G]oto [R]eferences")
    map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", fzf.lsp_typedefs, "Type [D]efinition")
    map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", fzf.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", function()
      vim.lsp.buf.hover(ui_options)
    end, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.server_capabilities.inlayHintProvider then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
      end, "[T]oggle Inlay [H]ints")
    end

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client.server_capabilities.signatureHelpProvider then
      -- vim.keymap.set("i", "<c-s-k>", vim.lsp.buf.signature_help, { buffer = event.buf })
      vim.keymap.set("i", "<c-s-k>", "<cmd>LspOverloadsSignature<CR>", { buffer = event.buf })
      vim.keymap.set(
        "n",
        "<c-s-k>",
        "<cmd>LspOverloadsSignature<CR>",
        { buffer = event.buf, silent = true, noremap = true }
      )

      require("lsp-overloads").setup(client, {
        ui = {
          border = "single",
          height = nil,
          width = nil,
          wrap = true,
          wrap_at = nil,
          max_width = nil,
          max_height = nil,
          close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
          focusable = false,
          focus = false,
          offset_x = 0,
          offset_y = 0,
          floating_window_above_cur_line = false,
          silent = true,
          highlight = {
            italic = true,
            bold = true,
            fg = "#ffffff",
          },
        },
        keymaps = {
          next_signature = "<A-j>",
          previous_signature = "<A-k>",
          next_parameter = "<A-l>",
          previous_parameter = "<A-h>",
          close_signature = "<c-s-k>",
        },
        display_automatically = false,
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
local servers = {
  ts_ls = {
    capabilities = {},
  },
  -- eslint = {
  --   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  --   settings = {
  --     workingDirectory = {
  --       mode = "auto",
  --     },
  --     format = { enable = false },
  --     lint = { enable = true },
  --   },
  -- },
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          },
        },
      },
    },
  },
}

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, server_config)
end

local ensure_installed = vim.tbl_keys(servers or {})

require("mason-lspconfig").setup({
  ensure_installed = ensure_installed,
  automatic_enable = true,
})

-- snippets

local snippets_folder = vim.fn.stdpath("config") .. "/snippets/"
vim.api.nvim_create_user_command("SnipEdit", 'lua require("luasnip.loaders").edit_snippet_files()', {})
require("luasnip.loaders.from_lua").load({ paths = snippets_folder })

local cmp = require("cmp")
-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
local luasnip = require("luasnip")
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-k>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
})
