local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then return end
ts.setup({
  ensure_installed = { "html" }, -- html parser used by leetcode.nvim to render question descriptions
  highlight = { enable = true },
  indent = { enable = true },
})
