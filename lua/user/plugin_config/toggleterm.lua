local ok, toggleterm = pcall(require, "toggleterm")
if not ok then return end
toggleterm.setup({
  direction = "float",
  open_mapping = [[<F7>]],
  float_opts = { border = "single", width = 170, height = 45 },
  close_on_exit = true,
  shade_terminals = true,
})
