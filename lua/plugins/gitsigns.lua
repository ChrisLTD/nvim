return {
	"lewis6991/gitsigns.nvim",
	opts = {},
	config = function(_, opts)
		local gitsigns = require("gitsigns")
		gitsigns.setup(opts)

		vim.keymap.set("n", "]h", gitsigns.next_hunk)
		vim.keymap.set("n", "[h", gitsigns.prev_hunk)
		vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk)
		vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
	end,
}
