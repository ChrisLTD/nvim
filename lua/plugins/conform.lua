local oxlint_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
local oxfmt_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }

-- Every ancestor, not just the nearest: a monorepo package declares its own
-- dependencies while the toolchain lives in the workspace root manifest, and
-- vim.fs.find defaults to limit = 1, which would stop at the package.
local function texts_above(bufnr, names)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return {}
	end
	local out = {}
	for _, path in
		ipairs(vim.fs.find(names, {
			upward = true,
			type = "file",
			limit = math.huge,
			path = vim.fs.dirname(name),
		}))
	do
		table.insert(out, table.concat(vim.fn.readfile(path), "\n"))
	end
	return out
end

-- Vite+ configures oxlint and oxfmt from vite.config.ts, so the filename alone
-- can't be a marker: it would select oxc in every Vite repo, prettier ones
-- included. Match on the field inside, the way nvim-lspconfig does.
local function vite_plus_configures(bufnr, field)
	for _, text in ipairs(texts_above(bufnr, { "vite.config.ts", "vite.config.js" })) do
		if text:find("vite%-plus") and text:find(field, 1, true) then
			return true
		end
	end
	return false
end

-- oxlint and oxfmt both run zero-config, so a project can adopt them with nothing
-- but a dependency. nvim-lspconfig treats a manifest naming the tool as a project
-- marker, and without this the LSP would attach while conform reached for eslint.
--
-- Matched as a quoted token, not a bare substring like nvim-lspconfig does, so
-- eslint-plugin-oxlint doesn't read as oxlint. That plugin is what oxc's own
-- migration guide has you add to a repo still running eslint, and a false positive
-- here is worse than one in the LSP: it wouldn't just show unwanted diagnostics,
-- it would let Mason's oxlint rewrite files on save. This makes conform's
-- detection a strict subset of the LSP's, which is the safe direction to differ.
local function manifest_declares(bufnr, tool)
	for _, text in ipairs(texts_above(bufnr, { "package.json", "package.json5" })) do
		if text:find('"' .. tool .. '"', 1, true) or text:find('"vite-plus"', 1, true) then
			return true
		end
	end
	return false
end

local function uses_oxc(bufnr, markers, tool, vite_field)
	return vim.fs.root(bufnr, markers) ~= nil
		or manifest_declares(bufnr, tool)
		or vite_plus_configures(bufnr, vite_field)
end

-- The fixer runs before the formatter so oxfmt/prettier cleans up after it.
-- Can't collapse into one list picked by availability: Mason installs oxlint for
-- the LSP and puts its bin dir on $PATH, so from_node_modules always resolves it
-- and oxlint would run in eslint-only repos.
local function js_formatters(bufnr)
	return {
		uses_oxc(bufnr, oxlint_markers, "oxlint", "lint:") and "oxlint" or "eslint_d",
		uses_oxc(bufnr, oxfmt_markers, "oxfmt", "fmt:") and "oxfmt" or "prettier",
	}
end

return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				go = { "gofmt" },
				javascript = js_formatters,
				javascriptreact = js_formatters,
				typescript = js_formatters,
				typescriptreact = js_formatters,
				lua = { "stylua" },
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end, { desc = "Format buffer" })
	end,
}
