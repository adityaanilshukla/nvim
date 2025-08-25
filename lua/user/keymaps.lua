vim.g.mapleader = " "

-- write / quit
vim.keymap.set('n', '<leader>w', ':silent write<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':qa<CR>',     { noremap = true, silent = true })

-- comments
vim.api.nvim_set_keymap('v', '<leader>/', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
  { noremap = true, silent = true, desc = "Toggle comment for selection" })

-- LSP format
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { noremap = true, silent = true })

-- spelling suggestions
vim.keymap.set("n", "sc", "z=", { noremap = true, silent = true })
vim.keymap.set("n", "gs", "z=", { noremap = true, silent = true })

-- splits
vim.keymap.set('n', '|',  ':vs<CR>',                        { noremap = true, desc = "Vertical Split" })
vim.keymap.set('n', '\\', '<cmd>split<CR><C-w>w',           { noremap = true, desc = "Horizontal Split" })

-- navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })

-- resize
vim.keymap.set("n", "<C-LEFT>",  "<C-w><", { silent = true })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { silent = true })
vim.keymap.set("n", "<C-Up>",    "<C-w>+", { silent = true })
vim.keymap.set("n", "<C-Down>",  "<C-w>-", { silent = true })

-- buffers
vim.keymap.set('n', '<leader>c',  '<cmd>bdelete<CR>',  { noremap = true, silent = true, desc = 'Close buffer' })
vim.keymap.set('n', '<leader>C',  '<cmd>bdelete!<CR>', { noremap = true, silent = true, desc = 'Force close buffer' })
vim.keymap.set('n', ']b',         '<cmd>bnext<CR>',    { noremap = true, silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '[b',         '<cmd>bprevious<CR>',{ noremap = true, silent = true, desc = 'Previous buffer' })

-- center buffer
vim.keymap.set('n', '<leader>cb', '<cmd>NoNeckPain<CR>', { noremap = true, silent = true, desc = 'Center buffer' })

-- file explorer
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>',      { noremap = true, silent = true })
vim.keymap.set('n', '<leader>o', function() require("user.utils").toggle_neotree_focus() end,
  { noremap = true, silent = true })

-- telescope
local ok_telescope, builtin = pcall(require, 'telescope.builtin')
if ok_telescope then
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fw', builtin.live_grep,  { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader>ft', function() builtin.colorscheme({ enable_preview = true }) end, { desc = 'Find themes' })
  vim.keymap.set('n', '<leader>h',  builtin.help_tags,  { desc = 'Search help tags' })
end

-- sessions
vim.keymap.set("n", "<leader>fs", "<cmd>SessionSearch<CR>", { desc = "Find session" })

-- terminal + lazygit
vim.keymap.set('n', '<F7>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gg', function() require("user.utils").lazygit_toggle() end,
  { noremap = true, silent = true, desc = 'Toggle LazyGit' })
