-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
	-- don't report change detection to the UI
	change_detection = { notify = false },
})

-- lazy.nvim has no minimum-release-age setting (folke/lazy.nvim#2141), so plugin
-- updates go through scripts/update-plugins, which only ever moves the lockfile
-- to commits that have been public for two weeks. Block the paths that would
-- jump straight to a branch tip and bypass that window.
--
-- Commands.cmd is the single choke point for both `:Lazy <cmd>` and the U/u/S
-- keys in the Lazy UI, so wrapping it covers every entry point except the
-- background checker (already disabled above).
local Commands = require("lazy.view.commands")
local lazy_cmd = Commands.cmd
local blocked = { update = true, sync = true }

Commands.cmd = function(cmd, opts)
	if blocked[cmd] then
		vim.notify(
			"`:Lazy " .. cmd .. "` is disabled -- run scripts/update-plugins --apply instead",
			vim.log.levels.WARN
		)
		return
	end
	return lazy_cmd(cmd, opts)
end
