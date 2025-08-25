local ok, dap_python = pcall(require, "dap-python")
if not ok then return end

local function python_path()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return vim.fn.exepath("python3")
  end
end

dap_python.setup(python_path())
