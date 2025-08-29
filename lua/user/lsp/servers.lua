-- Single source of truth for servers and their custom settings
local servers = {
	lua_ls = {
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	},
	ts_ls = {},
	pyright = {},
	clangd = {},
	bashls = {},
	jdtls = {},
	-- ltex = {}, -- temporarily blocked as it was causing that dumb Japanese error
	ltex = {
		cmd = { "ltex-ls-plus" }, -- <- use the forked server binary
		filetypes = { "tex", "plaintex", "markdown", "quarto", "rmd" },
		settings = {
			ltex = {
				language = "en-US",
				languageDetection = false,
				logLevel = "severe",
				-- your other prefs…
			},
		},
	},
	marksman = {},
}

return servers
