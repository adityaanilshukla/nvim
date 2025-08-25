-- Single source of truth for servers and their custom settings
local servers = {
  lua_ls = {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  ts_ls   = {},
  pyright = {},
  clangd  = {},
  bashls  = {},
  jdtls   = {},
  ltex    = {},
  marksman = {},
}

return servers
