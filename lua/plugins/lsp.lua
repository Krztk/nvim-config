return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "Krztk/omnisharp-extended-lsp.nvim", branch = "feat/add-support-for-snacks-picker" },
      "Issafalcon/lsp-overloads.nvim",
    },
    config = function()
      local ui_options = {
        border = "rounded",
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-plugin-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("snacks.picker").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("snacks.picker").lsp_references, "[G]oto [R]eferences")
          map("gI", require("snacks.picker").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("snacks.picker").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("snacks.picker").lsp_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("snacks.picker").lsp_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", function()
            vim.lsp.buf.hover(ui_options)
          end, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.name == "omnisharp" then
            map("gd", require("omnisharp_extended").snacks_picker_lsp_definitions, "[G]oto [D]efinition")
            map("gr", require("omnisharp_extended").snacks_picker_lsp_references, "[G]oto [R]eferences")
            map("gI", require("omnisharp_extended").snacks_picker_lsp_implementation, "[G]oto [I]mplementation")
          end

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
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
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

      vim.filetype.add({
        extension = {
          hurl = "hurl",
        },
      })

      vim.lsp.config("kt-hurl-lsp", {
        cmd = { "kt-hurl-lsp" },
        filetypes = { "hurl" },
        capabilities = capabilities,
      })
      vim.lsp.enable("kt-hurl-lsp")

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,
      })
    end,
  },
}
