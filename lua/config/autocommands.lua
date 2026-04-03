local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("auto-command-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd("BufEnter", {
  group = augroup("FormatOptions", { clear = true }),
  pattern = "*",
  desc = "Set buffer local formatoptions.",
  callback = function()
    -- Don't continue comments on o/O in normal mode.
    vim.opt_local.formatoptions:remove({
      "o",
    })
  end,
})
