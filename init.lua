-- plugins, we load these first before everything else
vim.pack.add({
	-- colorscheme plugins
	"https://github.com/vague2k/vague.nvim.git",
	"https://github.com/rebelot/kanagawa.nvim.git",
	"https://github.com/EdenEast/nightfox.nvim.git",
	-- telescope and dependency plugins
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

	-- Neotree
	"https://github.com/nvim-neo-tree/neo-tree.nvim.git",
	"https://github.com/MunifTanjim/nui.nvim.git",

	-- center buffer for ultrawide monitor
	"https://github.com/shortcuts/no-neck-pain.nvim.git",

	-- Language features and development tools
	"https://github.com/neovim/nvim-lspconfig.git",
	"https://github.com/numToStr/Comment.nvim.git",
	"https://github.com/Saghen/blink.cmp.git",

})

-- requirements
require("auto-session").setup({
	log_level = "error",
	auto_session_enable_last_session = false,
	auto_session_enabled = true,
	auto_save_enabled = true,
	auto_restore_enabled = true,
	auto_session_suppress_dirs = { "~/" }, -- don't save sessions in your home dir
})

local builtin = require('telescope.builtin')

require("bufferline").setup { options = { show_buffer_icons = true, } }
require("toggleterm").setup { direction = "float", open_mapping = [[<F7>]], float_opts = { border = "single", width = 170, height = 45, }, close_on_exit = true, shade_terminals = true, }
local Terminal = require('toggleterm.terminal').Terminal

require 'nvim-web-devicons'.setup {}
require("neo-tree").setup()

require("blink.cmp").setup({ fuzzy = { implementation = "lua", } })
local capabilities = require("blink.cmp").get_lsp_capabilities()

local lspconfig = require("lspconfig")
local servers = {
	"lua_ls", "ts_ls", "pyright", "clangd", "bashls", "jdtls",
}

for _, server in ipairs(servers) do
	if lspconfig[server] then
		local config = { capabilities = capabilities }

		if server == "lua_ls" then
			config.settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			}
		end

		lspconfig[server].setup(config)
	else
		vim.notify("LSP '" .. server .. "' not found", vim.log.levels.WARN)
	end
end

-- loop through all the language servers and set them up
local lsp = require("lspconfig")
local servers = {
	"jdtls", "clangd", "ts_ls", "pyright", "bashls", "lua_ls",
}

for _, srv in ipairs(servers) do
	if lsp[srv] then
		if srv == "lua_ls" then
			lsp.lua_ls.setup({
				settings = { Lua = { diagnostics = { globals = { "vim" } } } }
			})
		else
			lsp[srv].setup({})
		end
	else
		vim.notify("LSP '" .. srv .. "' not found in lspconfig", vim.log.levels.WARN)
	end
end

-- custom functions

-- lazygit terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = "float",
	float_opts = { border = "single", width = 170, height = 45, },
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

-- Function to toggle NeoTree focus
_G.toggle_neotree_focus = function()
	if vim.bo.filetype == "neo-tree" then
		vim.cmd("wincmd p")
	else
		vim.cmd("Neotree focus")
	end
end

-- Additional setup for NeoTree for copying paths
require('neo-tree').setup {
	window = {
		mappings = {
			['Y'] = function(state)
				local node = state.tree:get_node()
				local filepath = node:get_id()
				local filename = node.name
				local modify = vim.fn.fnamemodify

				local results = {
					filepath,
					modify(filepath, ':.'),
					modify(filepath, ':~'),
					filename,
					modify(filename, ':r'),
					modify(filename, ':e'),
				}

				local i = vim.fn.inputlist({
					'Choose to copy to clipboard:',
					'1. Absolute path: ' .. results[1],
					'2. Path relative to CWD: ' .. results[2],
					'3. Path relative to HOME: ' .. results[3],
					'4. Filename: ' .. results[4],
					'5. Filename without extension: ' .. results[5],
					'6. Extension of the filename: ' .. results[6],
				})

				if i > 0 then
					local result = results[i]
					if not result then return print('Invalid choice: ' .. i) end
					-- Use the "+ register for the system clipboard
					vim.fn.setreg('+', result)
					vim.notify('Copied: ' .. result)
				end
			end
		}
	}
}

-- mappings
vim.g.mapleader = " "

-- writing and saving
vim.keymap.set('n', '<leader>w', ':silent write<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':qa<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>o', ':source<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>/', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ noremap = true, silent = true, desc = "Toggle comment for selection" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { noremap = true, silent = true })

-- splits
vim.keymap.set('n', '|', ':vs<CR>', { noremap = true, desc = "Vertical Split" })
vim.keymap.set('n', '\\', '<cmd>split<CR><C-w>w', { noremap = true, desc = "Horizontal Split" })

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
vim.api.nvim_set_keymap('n', '<leader>C', '<cmd>bdelete!<CR>',
	{ noremap = true, silent = true, desc = 'Force close buffer' })
-- Next buffer
vim.api.nvim_set_keymap('n', ']b', '<cmd>bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
-- Previous buffer
vim.api.nvim_set_keymap('n', '[b', '<cmd>bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
-- center buffer
vim.api.nvim_set_keymap('n', '<leader>cb', '<cmd>NoNeckPain<CR>',
	{ noremap = true, silent = true, desc = 'Center buffer' })

-- fle explorer mappings
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>Neotree toggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', ':lua toggle_neotree_focus()<CR>', { noremap = true, silent = true })

-- telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>ft', function() require('telescope.builtin').colorscheme({ enable_preview = true }) end,
	{ desc = 'Find themes' })
vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'Search help tags' })

-- session lookup
vim.keymap.set("n", "<leader>fs", "<cmd>SessionSearch<CR>", { desc = "Find session" })

-- toggle term
vim.keymap.set('n', '<F7>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = true })

-- lazygit
vim.keymap.set('n', '<leader>gg', _lazygit_toggle, { noremap = true, silent = true, desc = 'Toggle LazyGit' })


-- options
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
vim.cmd("hi statusline guibg=NONE guifg=NONE")
vim.cmd("hi statuslineNC guibg=NONE guifg=NONE")
vim.opt.showmode = false -- hides -- INSERT --
vim.o.laststatus = 0
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.foldcolumn = "0"
vim.opt.showcmd = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.showtabline = 2
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
