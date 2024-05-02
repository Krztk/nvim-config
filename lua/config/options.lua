-- leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- case

-- mouse
vim.opt.mouse = 'a'

-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- width of a tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- 
vim.opt.swapfile = false

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear hlsearch on pressing <Esc> in normal mode