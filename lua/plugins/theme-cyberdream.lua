return {
	"scottmckendry/cyberdream.nvim",
	name = "cyberdream",
	lazy = false,
	priority = 1000,
	opts = {
		variant = "auto",
		overrides = function()
			if vim.o.background == "light" then
				return {
					CursorLine = { bg = "#f5f5f7" },
					ColorColumn = { bg = "#ededef" },
				}
			else
				return {
					CursorLine = { bg = "#1e2030" },
					ColorColumn = { bg = "#1e2030" },
				}
			end
		end,
	},
}
