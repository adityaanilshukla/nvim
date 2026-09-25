local ok, leetcode = pcall(require, "leetcode")
if not ok then
	return
end

-- The plugin never refreshes its own credential. It keeps whatever you typed
-- into its `Enter cookie` prompt in cache/cookie, and the first time LeetCode
-- rejects that session api/auth.lua calls delete_cookie(), wipes the file, and
-- puts the prompt back in your face -- roughly once a fortnight, always in the
-- middle of a problem.
--
-- The browser is holding a good session the whole time: LEETCODE_SESSION is a
-- sliding window that LeetCode pushes forward server-side on every page load.
-- scripts/leetcode-cookie copies that session over the cache file, so a browser
-- jar becomes the source of truth and the paste step disappears.
--
-- That jar is Firefox's, not Brave's, and the reason is macOS. Chromium-family
-- cookies are encrypted against a Keychain item, and every read of it raises a
-- password dialog -- "Always Allow" writes an ACL entry that never matches uv's
-- unsigned interpreter, so the grant does not stick. Unattended that is worse
-- than useless: the dialogs queue where nobody sees them. Firefox keeps
-- cookies.sqlite in plaintext, so this is a file read and nothing else.
--
-- Upkeep is a page load: only the browser that opens leetcode.com renews the
-- session, so Firefox needs to visit it every couple of weeks. The script warns
-- through here once it is down to its last few days.
--
-- Blocking is deliberate. The plugin reads the cookie while it starts, so the
-- copy has to land first; it only runs when leetcode is actually being opened,
-- never on an ordinary nvim launch, and a warm run costs a few hundred ms.
local leet_arg = "leetcode.nvim"

-- Put the days remaining on the command line. nvim_echo rather than notify
-- because this is a thing to glance at on the way in, not an event to dismiss,
-- and it is scheduled so it lands *after* :Leet has finished mounting the
-- plugin's UI -- echo before that and the redraw wipes it. Passing true keeps a
-- copy in :messages for when it scrolls past.
local function countdown(line, urgent)
	local days = tonumber(line:match("([%d%.]+) days left"))
	if not days then
		return
	end

	-- stop at the comma: the name is followed by ", <n> days left".
	local browser = line:match("session from ([^,%s]+)") or "the browser"
	local whole = math.floor(days)
	local unit = whole == 1 and "day" or "days"
	local msg, hl

	if whole < 1 then
		msg = ("LeetCode: session runs out today -- load leetcode.com in %s"):format(browser)
		hl = "ErrorMsg"
	elseif urgent then
		msg = ("LeetCode: %d %s left -- load leetcode.com in %s"):format(whole, unit, browser)
		hl = "WarningMsg"
	else
		msg = ("LeetCode: %d %s left"):format(whole, unit)
		hl = "MoreMsg"
	end

	vim.schedule(function()
		vim.api.nvim_echo({ { msg, hl } }, true, {})
	end)
end

local function sync_cookie()
	local script = vim.fn.stdpath("config") .. "/scripts/leetcode-cookie"
	if vim.fn.executable(script) == 0 then
		return
	end

	local cookie = vim.fn.stdpath("cache") .. "/leetcode/cookie"

	-- detach puts the child in its own process group, which is the only reason
	-- the kill below can reach the whole tree. It matters because what runs here
	-- is `uv run`, and uv execs the interpreter as a *grandchild*: SIGKILL to the
	-- pid nvim knows about leaves that python alive. A python blocked on a macOS
	-- Keychain prompt then sits there indefinitely holding the request, and the
	-- next sync queues behind it. Six had piled up before this guard existed.
	local obj = vim.system({ script, cookie }, { text = true, detach = true })
	local res = obj:wait(20000)

	if not res then
		pcall(vim.uv.kill, -obj.pid, "sigkill")
		vim.notify(
			"leetcode-cookie: no answer in 20s, killed. Either uv is still building "
				.. "its environment (run :LeetSync again), or the browser jar wants a "
				.. "Keychain unlock that nothing is around to answer.",
			vim.log.levels.WARN
		)
		return
	end

	local err = vim.trim(res.stderr or "")
	if res.code ~= 0 then
		vim.notify(err ~= "" and err or "leetcode-cookie: failed", vim.log.levels.WARN)
		return
	end

	-- On a run that worked, anything on stderr is the script's own "running out"
	-- nudge. Raise it as a warning so it lands in :messages, and let its mere
	-- presence decide how loud the countdown looks -- the script owns the
	-- threshold, and repeating the number over here would only let the two
	-- drift apart.
	if err ~= "" then
		vim.notify(err, vim.log.levels.WARN)
	end

	-- Hand the line back rather than echoing it here: only the caller knows
	-- whether a countdown is wanted, and on :Leet it is not if the plugin
	-- refused to open.
	return vim.trim(res.stdout or ""), err ~= ""
end

-- For the times the session dies underneath a running nvim: re-copy, then let
-- the plugin retry. Re-login after an expiry is otherwise a paste.
vim.api.nvim_create_user_command("LeetSync", function()
	countdown(sync_cookie())
end, { desc = "Refresh the LeetCode cookie from the browser" })

-- Opened as `nvim leetcode.nvim`. This mirrors the guard the plugin itself uses
-- in should_skip(), and runs now because its VimEnter handler fires later.
if vim.fn.argc(-1) == 1 and vim.fn.argv(0, -1) == leet_arg then
	countdown(sync_cookie())
end

leetcode.setup({
	lang = "python3",
	picker = { provider = "telescope" },
	injector = {},
	arg = leet_arg,
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

-- setup() has just bound :Leet to a bare start stub. Take it over so the cookie
-- is refreshed on this path too -- the `nvim leetcode.nvim` guard above misses
-- it, and with vim.pack the plugin is always loaded, so :Leet in an ordinary
-- session is the usual way in. The takeover undoes itself: a successful start
-- runs the plugin's own cmd.setup(), which rebinds :Leet to the full
-- subcommand version, leaving :Leet run and friends untouched.
--
-- This mirrors the plugin's start_with_cmd rather than calling it, for the sake
-- of that `if`. start() refuses to open when the session already has listed
-- buffers and explains itself through vim.notify, which prints immediately --
-- whereas the countdown is scheduled, so echoing it unconditionally landed on
-- top of that explanation and left :Leet looking like it had silently done
-- nothing. The countdown now only speaks when the plugin actually opened.
vim.api.nvim_create_user_command("Leet", function()
	local line, urgent = sync_cookie()

	if leetcode.start(false) then
		require("leetcode.command").menu()
		countdown(line, urgent)
	end
end, { bar = true, bang = true, desc = "Open leetcode.nvim" })
