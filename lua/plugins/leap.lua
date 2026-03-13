return {
	"https://codeberg.org/andyg/leap.nvim",
	config = function()
		local leap = require("leap")

		vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap)")

		vim.keymap.set("n", "F", "<Plug>(leap-from-window)")
	end,
}
