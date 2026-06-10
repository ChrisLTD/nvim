-- Popup showing available keybindings when you pause after a prefix
-- (e.g. <leader>). Reads `desc` from existing keymaps.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
}
