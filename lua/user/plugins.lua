-- plugins.lua
vim.pack.add({
	-- colors / UI
	"https://github.com/vague2k/vague.nvim.git",
	"https://github.com/rebelot/kanagawa.nvim.git",
	"https://github.com/EdenEast/nightfox.nvim.git",
	"https://github.com/nvim-lualine/lualine.nvim.git",
	"https://github.com/nvim-tree/nvim-web-devicons.git",
	"https://github.com/lukas-reineke/indent-blankline.nvim.git",
	"https://github.com/folke/which-key.nvim.git",

	-- telescope + deps
	"https://github.com/nvim-lua/plenary.nvim.git",
	"https://github.com/nvim-telescope/telescope.nvim.git",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git", version = "main" },

	-- session
	"https://github.com/rmagatti/auto-session.git",

	-- tabs
	"https://github.com/akinsho/bufferline.nvim.git",

	-- floating terminal
	"https://github.com/akinsho/toggleterm.nvim.git",

	-- file explorer
	"https://github.com/nvim-neo-tree/neo-tree.nvim.git",
	"https://github.com/MunifTanjim/nui.nvim.git",

	-- center buffer
	"https://github.com/shortcuts/no-neck-pain.nvim.git",

	-- LSP / editing / debug
	"https://github.com/neovim/nvim-lspconfig.git",
	"https://github.com/numToStr/Comment.nvim.git",
	-- blink.lib must be listed, and listed before blink.cmp. blink.cmp v2 split
	-- its shared code out into this package and hard-requires it: without it,
	-- every launch printed "loop or previous error loading module 'blink.cmp'",
	-- which is Lua reporting a cached failure rather than the real one. The
	-- actual message, only visible by requiring it in a clean nvim, was
	-- 'blink.cmp v2 requires "saghen/blink.lib" installed via your package
	-- manager'.
	--
	-- It was already cloned into pack/core/opt and already in
	-- nvim-pack-lock.json; it was missing only from here. opt packages are not
	-- on the runtimepath until something adds them, so being on disk counted
	-- for nothing.
	"https://github.com/saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp.git",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
	"https://github.com/mfussenegger/nvim-dap.git",
	"https://github.com/rcarriga/nvim-dap-ui.git",
	"https://github.com/nvim-neotest/nvim-nio.git",
	"https://github.com/mfussenegger/nvim-dap-python.git",
	"https://github.com/stevearc/conform.nvim.git",
	"https://github.com/mfussenegger/nvim-lint.git",
	"https://github.com/lervag/vimtex.git",
	"https://github.com/SirVer/ultisnips.git",

	-- Practice Leetcode
	"https://github.com/kawre/leetcode.nvim",
})
