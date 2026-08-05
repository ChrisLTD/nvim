-- Custom statusline: mode, project-relative path, modified flag on the left;
-- git branch, scroll percent, diagnostic counts on the right.
-- Functions are global so the statusline can call them via v:lua.

function StatuslineBranch()
	local branch = vim.fn.FugitiveHead()
	-- filter out common branch prefixes
	branch = branch:gsub("^chrisltd/", ""):gsub("^feature/eng%-", "")
	-- truncate long branch names
	return branch:sub(1, 30)
end

-- Path relative to the nearest .git ancestor (so it stays project-relative
-- regardless of cwd). Falls back to the filename when the buffer isn't in a
-- git repo. Always compacted with pathshorten 1 char per directory.
function StatuslinePath()
	local abs = vim.fn.expand("%:p")
	-- Unnamed buffers (dashboard, scratch, :new without a name) -> show nothing.
	if abs == "" then
		return ""
	end
	local root = vim.fs.root(0, { ".git" })
	local path
	if root and abs:sub(1, #root + 1) == root .. "/" then
		path = abs:sub(#root + 2)
	else
		-- :t = "tail" modifier -> just the filename, no directories.
		path = vim.fn.fnamemodify(abs, ":t")
	end
	return vim.fn.pathshorten(path, 1)
end

-- Current mode letter colored by mode family (reuses core syntax highlight
-- groups so it adapts to whichever colorscheme is active). Embed via %{%...%}.
function StatuslineMode()
	local m = vim.fn.mode()
	local hl_by_mode = {
		n = "Function", -- NORMAL
		i = "String", -- INSERT  (typically green)
		v = "Constant", -- VISUAL  (typically orange/magenta)
		V = "Constant", -- V-LINE
		["\22"] = "Constant", -- V-BLOCK (CTRL-V)
		s = "Constant", -- SELECT
		S = "Constant",
		["\19"] = "Constant",
		R = "DiagnosticError", -- REPLACE (red)
		c = "DiagnosticWarn", -- COMMAND (yellow)
		t = "String", -- TERMINAL
	}
	local hl = hl_by_mode[m] or "Function"
	return "%#" .. hl .. "#" .. m:upper() .. "%*"
end

-- Modified flag: "[+]" in yellow when the buffer has unsaved changes, otherwise
-- empty. Replaces the built-in %m so we can color it. Embed via %{%...%}.
function StatuslineModified()
	if vim.bo.modified then
		return "%#DiagnosticWarn#[+]%*"
	end
	return ""
end

-- Error/warning counts for the current buffer, e.g. "E:2 W:1" with E in red and
-- W in yellow (reusing the built-in DiagnosticError / DiagnosticWarn highlight
-- groups so colors match virtual text and signs). Empty when clean.
-- Info and hint are intentionally omitted -- too noisy and rarely actionable.
-- Must be embedded in the statusline via %{%...%} (not %{...}) so the
-- %#Group# highlight markers in the returned string are interpreted.
function StatuslineDiagnostics()
	local s = vim.diagnostic.severity
	local counts = vim.diagnostic.count(0)
	local parts = {}
	if (counts[s.ERROR] or 0) > 0 then
		table.insert(parts, "%#DiagnosticError#E:" .. counts[s.ERROR] .. "%*")
	end
	if (counts[s.WARN] or 0) > 0 then
		table.insert(parts, "%#DiagnosticWarn#W:" .. counts[s.WARN] .. "%*")
	end
	return table.concat(parts, " ")
end

vim.opt.statusline =
	" %{%v:lua.StatuslineMode()%} %{v:lua.StatuslinePath()} %{%v:lua.StatuslineModified()%} %r %= %{v:lua.StatuslineBranch()} %P %{%v:lua.StatuslineDiagnostics()%} "

-- Refresh statusline when diagnostics change so the counter stays current
-- even while idle (e.g. LSP publishes a result after a save).
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})
