return {
	"lewis6991/gitsigns.nvim",
	opts = {},
	config = function(_, opts)
		local gitsigns = require("gitsigns")
		gitsigns.setup(opts)

		vim.keymap.set("n", "]h", function()
			gitsigns.nav_hunk("next")
		end, { desc = "Next git hunk" })
		vim.keymap.set("n", "[h", function()
			gitsigns.nav_hunk("prev")
		end, { desc = "Prev git hunk" })
		vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
	end,
}
