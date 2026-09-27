-- Blink cmp setup + capabilities
local capabilities = require("user.lsp.capabilities")

-- Servers list + per-server config
local servers = require("user.lsp.servers")

-- nvim-lspconfig is now only a data package: it ships one lsp/<name>.lua per
-- server on the runtimepath, which vim.pack.add already puts there, and
-- vim.lsp.config/vim.lsp.enable read those directly. Requiring the module and
-- calling lspconfig[name].setup() is the old "framework" path, deprecated in
-- nvim-lspconfig 2.x and slated to be removed in 3.0 -- and it does not fail
-- quietly: every launch printed the deprecation notice with a six-line stack
-- traceback.
--
-- Nothing here pins a version, so the two machines drift: ello was still on an
-- lspconfig old enough not to warn while molly had already moved past it. The
-- warning was never machine-specific, only the update was.

-- Applied to every server, including any configured only by its upstream
-- lsp/<name>.lua. Merged under the per-server tables below, so a server may
-- still override it.
vim.lsp.config("*", { capabilities = capabilities })

-- Merged over the upstream lsp/<name>.lua rather than replacing it, the same way
-- setup() extended lspconfig's defaults. List values like ltex's cmd are
-- replaced wholesale, which is what that override wants.
for name, cfg in pairs(servers) do
	if cfg and next(cfg) ~= nil then
		vim.lsp.config(name, cfg)
	end
end

vim.lsp.enable(vim.tbl_keys(servers))
