vim.cmd("colorscheme carbonfox")
vim.cmd("set completeopt+=noselect")

vim.opt.number = true
vim.opt.relativenumber = true
vim.wo.winfixwidth = true
vim.wo.wrap = false
vim.o.clipboard = "unnamedplus"
vim.o.fillchars = "eob: "
vim.o.tabstop = 4
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.foldcolumn = "0"
vim.opt.showcmd = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions,"
vim.o.showtabline = 2
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.opt.spelllang = { "en_us" }
vim.opt.spell = true

-- statusline transparency like before
vim.cmd("hi statusline guibg=NONE guifg=NONE")
vim.cmd("hi statuslineNC guibg=NONE guifg=NONE")
