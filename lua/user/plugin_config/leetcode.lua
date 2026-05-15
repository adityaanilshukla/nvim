local ok, leetcode = pcall(require, "leetcode")
if not ok then
	return
end

leetcode.setup({
	lang = "python3",
	picker = { provider = "telescope" },
	injector = {},
	storage = {
		home = vim.fn.stdpath("data") .. "/leetcode",
		cache = vim.fn.stdpath("cache") .. "/leetcode",
	},
})
