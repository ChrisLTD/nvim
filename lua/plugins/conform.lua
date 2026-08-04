local oxlint_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
local oxfmt_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }

-- Projects move from eslint/prettier to the oxc toolchain one at a time, so pick
-- the chain from whichever config files the project actually has. The fixer runs
-- before the formatter so oxfmt/prettier cleans up whatever the fixer leaves behind.
--
-- This can't collapse into a single list that lets conform pick by availability:
-- Mason installs oxlint for the LSP and puts its bin dir on $PATH, so
-- from_node_modules always resolves it and oxlint would run in eslint-only repos.
local function js_formatters(bufnr)
	return {
		vim.fs.root(bufnr, oxlint_markers) and "oxlint" or "eslint_d",
		vim.fs.root(bufnr, oxfmt_markers) and "oxfmt" or "prettier",
	}
end

return {
	"stevearc/conform.nvim",
	opts = {},
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
