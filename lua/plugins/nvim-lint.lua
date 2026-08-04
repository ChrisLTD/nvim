local cspell_markers = {
	"cspell.json",
	".cspell.json",
	"cSpell.json",
	"cspell.config.js",
	"cspell.config.cjs",
	"cspell.config.mjs",
	"cspell.config.json",
	"cspell.config.yaml",
	"cspell.config.yml",
	"cspell.yaml",
	"cspell.yml",
}

local cspell_json_markers = { "cspell.json", ".cspell.json", "cSpell.json", "cspell.config.json" }

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

local function cspell_root(bufnr)
	return vim.fs.root(bufnr, cspell_markers)
end

local function local_cspell(root)
	local bin = vim.fs.joinpath(root, "node_modules", ".bin", "cspell")
	return vim.uv.fs_stat(bin) and bin or nil
end

-- Yank the word and open the dictionary rather than editing it in place: writing
-- into the words array without clobbering the file's own formatting takes far
-- more code than pasting one line is worth.
local function open_cspell_dictionary()
	local name = vim.api.nvim_buf_get_name(0)
	local path = name ~= ""
		and vim.fs.find(cspell_json_markers, { upward = true, type = "file", path = vim.fs.dirname(name) })[1]
	if not path then
		vim.notify("No cspell JSON config found for this buffer", vim.log.levels.WARN)
		return
	end

	vim.fn.setreg('"', vim.fn.expand("<cword>"))
	vim.cmd.edit(vim.fn.fnameescape(path))
	vim.fn.search('"words"')
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	config = function()
		local lint = require("lint")

		lint.linters.cspell = vim.tbl_extend("force", require("lint.linters.cspell"), {
			-- Evaluated with the process cwd set to the project root, so the
			-- relative path resolves against the project rather than nvim's cwd.
			cmd = function()
				local bin = vim.fn.fnamemodify("./node_modules/.bin/cspell", ":p")
				return vim.uv.fs_stat(bin) and bin or "cspell"
			end,
		})

		for _, ft in ipairs(cspell_filetypes) do
			lint.linters_by_ft[ft] = { "cspell" }
		end

		-- Only lint where the project actually configures cspell, so repos
		-- without it don't get flooded with default-dictionary noise.
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function(event)
				local root = cspell_root(event.buf)
				if not root or not (local_cspell(root) or vim.fn.executable("cspell") == 1) then
					return
				end
				lint.try_lint(nil, { cwd = root })
			end,
		})

		vim.keymap.set("n", "<leader>aw", open_cspell_dictionary, { desc = "Open cspell dictionary at words" })
	end,
}
