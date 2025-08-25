local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then return end
ts.setup({
  ensure_installed = {}, -- add languages if you want
  highlight = { enable = true },
  indent = { enable = true },
})
