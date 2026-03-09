return {
  {
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local wk = require("which-key")
      wk.setup({
        plugins = {
          registers = false,
        },
      })

      -- Document existing key chains
      wk.add({
        { "<leader>c", group = "[C]ode" },
        { "<leader>p", group = "[P]ilot" },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename/[R]eplace" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>h", group = "[H]url" },
        { "<leader>w", group = "[W]orkspace" },
      })
    end,
  },
}
