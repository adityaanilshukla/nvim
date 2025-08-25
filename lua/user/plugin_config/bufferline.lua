local ok, bufferline = pcall(require, "bufferline")
if not ok then return end
bufferline.setup({ options = { show_buffer_icons = true } })
