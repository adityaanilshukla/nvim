local M = {}

-- Neo-tree focus toggle
function M.toggle_neotree_focus()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd("wincmd p")
  else
    vim.cmd("Neotree focus")
  end
end

-- lazygit terminal via toggleterm
local ok_term, Terminal = pcall(function() return require('toggleterm.terminal').Terminal end)
local lazygit_term = ok_term and Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = { border = "single", width = 170, height = 45 },
  on_open = function() vim.cmd("startinsert!") end,
  on_close = function() vim.cmd("startinsert!") end,
}) or nil

function M.lazygit_toggle()
  if not lazygit_term then
    vim.notify("toggleterm or lazygit not available", vim.log.levels.ERROR)
    return
  end
  lazygit_term:toggle()
end

return M
