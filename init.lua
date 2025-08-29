require("user.plugins") -- install/declare plugins early
require("user.options")
require("user.keymaps")
require("user.diagnostics")

-- plugin configs (safe to split; each file does its own pcall)
require("user.plugin_config.theme")
require("user.plugin_config.auto-session")
require("user.plugin_config.devicons")
require("user.plugin_config.lualine")
require("user.plugin_config.indent-blankline")
require("user.plugin_config.which-key")
require("user.plugin_config.telescope")
require("user.plugin_config.treesitter")
require("user.plugin_config.bufferline")
require("user.plugin_config.toggleterm")
require("user.plugin_config.neo-tree")
require("user.plugin_config.comment")
require("user.plugin_config.render-markdown")
require("user.plugin_config.conform")
require("user.plugin_config.nvim-lint")
require("user.plugin_config.vimtex")
require("user.plugin_config.utilsnips")

-- features
require("user.lsp") -- loads lsp/init.lua
require("user.dap") -- loads dap/init.lua

-- optional
pcall(require, "user.autocmds")
