local filetypes = {
  javascript = { "javascriptreact", "ecma", "ecmascript", "jsx", "js" },
  tsx = { "typescriptreact", "typescript.tsx" },
  typescript = { "ts" },
}

for lang, ft in pairs(filetypes) do
  vim.treesitter.language.register(lang, ft)
end

local treesitter_folder = vim.fn.stdpath("data") .. "/treesitter-data"
vim.opt.runtimepath:append(treesitter_folder)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact" },
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
