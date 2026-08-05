return {
	{ "mason-org/mason.nvim", opts = {} },

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig", "saghen/blink.cmp" },
		opts = {
			-- eslint and oxlint each require their own config file to be present
			-- before they attach, so they self-select per repo while projects
			-- migrate from one to the other.
			ensure_installed = { "ts_ls", "gopls", "eslint", "oxlint", "lua_ls" },
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
			vim.lsp.enable(opts.ensure_installed)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local o = { buffer = event.buf }

					-- Jump to where the symbol is defined
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", o, { desc = "Go to definition" })
					)

					-- Jump to the declaration
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", o, { desc = "Go to declaration" })
					)

					-- List all references to the symbol under cursor
					vim.keymap.set(
						"n",
						"gr",
						vim.lsp.buf.references,
						vim.tbl_extend("force", o, { desc = "References" })
					)

					-- Jump to the implementation
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", o, { desc = "Go to implementation" })
					)

					-- Show hover documentation
					vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Hover docs" }))

					-- Rename the symbol under cursor across the project
					vim.keymap.set(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						vim.tbl_extend("force", o, { desc = "Rename symbol" })
					)

					-- Show available code actions (quick fixes, refactors)
					vim.keymap.set(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", o, { desc = "Code actions" })
					)

					-- Add missing imports (filetype-aware: gopls / ts_ls)
					vim.keymap.set("n", "<leader>ci", function()
						local kind_by_ft = {
							go = "source.organizeImports",
							typescript = "source.addMissingImports.ts",
							typescriptreact = "source.addMissingImports.ts",
							javascript = "source.addMissingImports.ts",
							javascriptreact = "source.addMissingImports.ts",
						}
						local kind = kind_by_ft[vim.bo.filetype]
						if not kind then
							vim.notify("No import action for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
							return
						end
						vim.lsp.buf.code_action({
							context = { only = { kind }, diagnostics = {} },
							apply = true,
						})
					end, vim.tbl_extend("force", o, { desc = "Add missing imports" }))

					-- Show diagnostic details in a floating window
					vim.keymap.set(
						"n",
						"<leader>e",
						vim.diagnostic.open_float,
						vim.tbl_extend("force", o, { desc = "Float diagnostics" })
					)
				end,
			})

			-- Run gopls' organizeImports synchronously before save (goimports behavior)
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0, name = "gopls" })) do
						local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
						params.context = { only = { "source.organizeImports" }, diagnostics = {} }
						local results = client:request_sync("textDocument/codeAction", params, 3000, 0)
						for _, action in pairs(results and results.result or {}) do
							if action.edit then
								vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
							end
						end
					end
				end,
			})
		end,
	},
}
