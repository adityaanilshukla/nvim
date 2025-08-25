-- Configure blink.cmp once and export capabilities for lspconfig
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  blink.setup({ fuzzy = { implementation = "lua" } })
  return blink.get_lsp_capabilities()
end

-- fallback
return vim.lsp.protocol.make_client_capabilities()
