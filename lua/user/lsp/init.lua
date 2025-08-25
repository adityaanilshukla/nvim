-- Blink cmp setup + capabilities
local capabilities = require("user.lsp.capabilities")

-- Servers list + per-server config
local servers = require("user.lsp.servers")

local ok_lsp, lspconfig = pcall(require, "lspconfig")
if not ok_lsp then return end

for name, cfg in pairs(servers) do
  local conf = vim.tbl_deep_extend("force", { capabilities = capabilities }, cfg or {})
  lspconfig[name].setup(conf)
end
