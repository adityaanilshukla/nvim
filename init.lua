
-- plugins, we load these first before everything else 
vim.pack.add({
-- colorscheme plugins
"https://github.com/catppuccin/nvim.git",

-- telescope plugins
"https://github.com/nvim-lua/plenary.nvim.git",
"https://github.com/nvim-telescope/telescope.nvim.git",
"https://github.com/nvim-treesitter/nvim-treesitter.git",

-- session saver
"https://github.com/rmagatti/auto-session.git",

-- tabs
"https://github.com/akinsho/bufferline.nvim.git",

-- floating terminal
"https://github.com/akinsho/toggleterm.nvim.git",

-- icons
"https://github.com/nvim-tree/nvim-web-devicons.git",

})

-- requirements
require("auto-session").setup({
  log_level = "error",
  auto_session_enable_last_session = false,
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = { "~/" },  -- don't save sessions in your home dir
})

local builtin = require('telescope.builtin')

require("bufferline").setup {options = {show_buffer_icons = true,}}
require("toggleterm").setup{ direction = "float", open_mapping = [[<F7>]], float_opts = {border = "single",width = 170,height = 45,},close_on_exit = true,shade_terminals = true,}
local Terminal = require('toggleterm.terminal').Terminal

require'nvim-web-devicons'.setup {}


-- custom functions

-- lazygit terminal
local lazygit = Terminal:new({cmd = "lazygit", hidden = true, direction = "float", float_opts = {border = "single",width = 170, height = 45,},
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end

-- mappings
vim.g.mapleader = " "

-- writing and saving
vim.keymap.set('n', '<leader>w', ':write<CR>', {noremap = true})
vim.keymap.set('n', '<leader>q', ':quit<CR>', {noremap = true})
vim.keymap.set('n', '<leader>x', ':qa<CR>', {noremap = true})

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', {noremap = true})

-- splits
vim.keymap.set('n', '|', ':vs<CR>', {noremap = true, desc = "Vertical Split"})
vim.keymap.set('n', '\\', '<cmd>split<CR><C-w>w',{noremap = true, desc = "Horizontal Split"})

-- navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })

-- resizing
vim.keymap.set("n", "<C-LEFT>", "<C-w><", { silent = true })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { silent = true })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { silent = true })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { silent = true })

-- buffer mappings
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>bdelete<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
-- force close 
vim.api.nvim_set_keymap('n', '<leader>C', '<cmd>bdelete!<CR>', { noremap = true, silent = true, desc = 'Force close buffer' })
-- Next buffer
vim.api.nvim_set_keymap('n', ']b', '<cmd>bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
-- Previous buffer
vim.api.nvim_set_keymap('n', '[b', '<cmd>bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })

-- telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = 'Telescope live grep' })

-- session lookup
vim.keymap.set("n", "<leader>fs", "<cmd>SessionSearch<CR>", { desc = "Find session" })

-- toggle term
vim.keymap.set('n', '<F7>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = true })

-- lazygit
vim.keymap.set('n', '<leader>gg', _lazygit_toggle, { noremap = true, silent = true, desc = 'Toggle LazyGit' })


-- options
-- vim.cmd.colorscheme "catppuccin"
vim.opt.number = true
vim.opt.relativenumber = true
vim.wo.winfixwidth = true
vim.wo.wrap = false
vim.o.clipboard = "unnamedplus"
vim.o.fillchars = "eob: "
vim.o.tabstop = 4 
vim.opt.swapfile = false
vim.cmd("hi statusline guibg=NONE guifg=NONE")
vim.cmd("hi statuslineNC guibg=NONE guifg=NONE")
vim.opt.showmode = false -- hides -- INSERT --
vim.o.laststatus = 0
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.signcolumn = "no"
vim.opt.foldcolumn = "0"
vim.opt.showcmd = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.showtabline = 2
vim.opt.termguicolors = true

