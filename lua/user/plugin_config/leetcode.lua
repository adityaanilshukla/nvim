local ok, leetcode = pcall(require, "leetcode")
if not ok then
	return
end

leetcode.setup({
	lang = "python3",
	picker = { provider = "telescope" },
	injector = {},
	-- home holds the solution files, and lives in Documents because Syncthing
	-- replicates that tree to every machine. Solving a problem on one laptop
	-- and continuing on another is the whole point.
	--
	-- A literal "~" rather than an absolute path: the plugin expands it
	-- (config/init.lua runs vim.fn.expand over storage), and this repo is
	-- shared with brovo, where HOME is /home/aditya.
	--
	-- Its own subdirectory rather than BUCK_TFUP itself. The plugin does
	-- nvim_set_current_dir(storage.home) whenever it opens, so a flat layout
	-- would make the notes directory the working directory, and the generated
	-- .py files would sit among the .md notes.
	--
	-- cache deliberately stays local and is NOT synced. It holds `cookie`,
	-- which is the LeetCode session credential, plus a problem list and a
	-- scratch `body` file. A credential does not belong in a replicated tree,
	-- and the other two are per-machine and regenerate themselves.
	--
	-- Shared storage means concurrent edits to the same solution on two
	-- machines produce a Syncthing *.sync-conflict-* file rather than a merge.
	-- That is the cost of this over a git repo; finish a problem on one
	-- machine before picking it up on the other.
	storage = {
		home = "~/Documents/Notes/BUCK_TFUP/leetcode",
		cache = vim.fn.stdpath("cache") .. "/leetcode",
	},
})
