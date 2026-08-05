-- cspell's own searchPlaces, verbatim and in order. This is a precedence list,
-- and it includes nested paths like .vscode/cspell.json, so it can't be reduced
-- to basenames for vim.fs.find -- the search below walks it per directory
-- instead. Copied rather than derived: the ordering is irregular.
local cspell_markers = {
	"package.json",
	".cspell.json",
	"cspell.json",
	".cSpell.json",
	"cSpell.json",
	".cspell.jsonc",
	"cspell.jsonc",
	".vscode/cspell.json",
	".vscode/cSpell.json",
	".vscode/.cspell.json",
	".cspell.config.json",
	".cspell.config.jsonc",
	".cspell.config.yaml",
	".cspell.config.yml",
	"cspell.config.json",
	"cspell.config.jsonc",
	"cspell.config.yaml",
	"cspell.config.yml",
	"cspell.config.mjs",
	"cspell.config.cjs",
	"cspell.config.js",
	"cspell.config.toml",
	"cspell.config.mts",
	"cspell.config.ts",
	"cspell.config.cts",
	".cspell.config.mjs",
	".cspell.config.cjs",
	".cspell.config.js",
	".cspell.config.toml",
	".cspell.config.mts",
	".cspell.config.ts",
	".cspell.config.cts",
	".cspell.yaml",
	".cspell.yml",
	"cspell.yaml",
	"cspell.yml",
	".config/.cspell.json",
	".config/cspell.json",
	".config/.cSpell.json",
	".config/cSpell.json",
	".config/.cspell.jsonc",
	".config/cspell.jsonc",
	".config/cspell.config.json",
	".config/cspell.config.jsonc",
	".config/cspell.config.yaml",
	".config/cspell.config.yml",
	".config/cspell.config.mjs",
	".config/cspell.config.cjs",
	".config/cspell.config.js",
	".config/cspell.config.toml",
	".config/cspell.config.mts",
	".config/cspell.config.ts",
	".config/cspell.config.cts",
	".config/.cspell.config.json",
	".config/.cspell.config.jsonc",
	".config/.cspell.config.yaml",
	".config/.cspell.config.yml",
	".config/.cspell.config.mjs",
	".config/.cspell.config.cjs",
	".config/.cspell.config.js",
	".config/.cspell.config.toml",
	".config/.cspell.config.mts",
	".config/.cspell.config.ts",
	".config/.cspell.config.cts",
	".config/cspell.yaml",
	".config/cspell.yml",
}

local cspell_filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"go",
	"lua",
	"markdown",
	"json",
	"yaml",
	"gitcommit",
}

-- Decoded rather than pattern-matched: a `"cspell"` devDependency would match a
-- textual search, and treating that as config would hand --config a package.json
-- with no settings in it, overriding the real config file.
local function package_declares_cspell(path)
	local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
	return ok and type(decoded) == "table" and decoded.cspell ~= nil
end

-- git keeps a linked worktree's COMMIT_EDITMSG under the *main* repo, at
-- .git/worktrees/<name>/, so walking up from a gitcommit buffer lands in the
-- wrong checkout and misses that worktree's config and node_modules entirely.
-- git runs the editor from the worktree, so cwd is the origin to search from.
local function search_origin(bufnr)
	if vim.bo[bufnr].filetype == "gitcommit" then
		return vim.fn.getcwd()
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	return name ~= "" and vim.fs.dirname(name) or nil
end

-- Walked per directory rather than handed to vim.fs.find, because the marker
-- list contains nested paths and find only matches basenames. Checking every
-- place in every directory costs ~2ms when nothing is found, which is the common
-- case in repos without cspell, so the result is cached: a config appearing
-- mid-session needs the buffer reopened to be picked up.
--
-- Keyed by directory rather than buffer, so a buffer that moves between projects
-- (:saveas, :file) is looked up afresh. An unnamed buffer has no origin to key
-- on and isn't cached at all -- caching that against its buffer number would
-- outlive the rename and suppress linting in whatever project it lands in.
local resolved = {}

local function lookup(bufnr)
	local origin = search_origin(bufnr)
	if not origin then
		return { config = false, bin = false }
	end

	local cached = resolved[origin]
	if cached then
		return cached
	end
	local found = { config = false, bin = false }

	for dir in vim.fs.parents(vim.fs.joinpath(origin, "x")) do
		if not found.config then
			for _, marker in ipairs(cspell_markers) do
				local path = vim.fs.joinpath(dir, marker)
				if
					vim.uv.fs_stat(path)
					and (vim.fs.basename(path) ~= "package.json" or package_declares_cspell(path))
				then
					found.config = path
					break
				end
			end
		end
		if not found.bin then
			-- Every ancestor node_modules, the way Node resolves binaries: a
			-- monorepo package can carry its own cspell config while the
			-- dependency is hoisted to the workspace root.
			local bin = vim.fs.joinpath(dir, "node_modules", ".bin", "cspell")
			if vim.uv.fs_stat(bin) then
				found.bin = bin
			end
		end
		if found.config and found.bin then
			break
		end
	end

	resolved[origin] = found
	return found
end

local function cspell_config(bufnr)
	return lookup(bufnr).config or nil
end

local function local_cspell(bufnr)
	return lookup(bufnr).bin or nil
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	config = function()
		local lint = require("lint")
		local builtin = require("lint.linters.cspell")

		-- cspell resolves its config from the process cwd when the target is a
		-- stdin:// URI, and pointing nvim-lint at the project root to arrange that
		-- makes it :cd globally, clobbering any :lcd. Naming the config outright
		-- removes the dependency on cwd entirely.
		local args = vim.deepcopy(builtin.args)
		table.insert(args, 2, "--config")
		table.insert(args, 3, function()
			return cspell_config(0)
		end)

		lint.linters.cspell = vim.tbl_extend("force", builtin, {
			cmd = function()
				return local_cspell(0) or "cspell"
			end,
			args = args,
		})

		for _, ft in ipairs(cspell_filetypes) do
			lint.linters_by_ft[ft] = { "cspell" }
		end

		-- Only lint where the project actually configures cspell, so repos
		-- without it don't get flooded with default-dictionary noise.
		--
		-- Two things are load-bearing here. The augroup: lazy.nvim replays the
		-- loading event per augroup, so a groupless autocmd never fires for the
		-- buffer that triggered the load. And FileType rather than BufReadPost:
		-- filetype detection runs after BufReadPost, so try_lint would look up
		-- linters for an empty filetype and silently do nothing.
		vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim_lint_cspell", { clear = true }),
			callback = function(event)
				if not cspell_config(event.buf) then
					return
				end
				if not (local_cspell(event.buf) or vim.fn.executable("cspell") == 1) then
					return
				end
				lint.try_lint()
			end,
		})
	end,
}
