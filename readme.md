# Neovim Configuration

A minimal, Lua-based Neovim configuration focused on TypeScript and Go development.

## Prerequisites

- **Neovim**: `brew install neovim`
- **Nerd Font**: `brew install --cask font-jetbrains-mono-nerd-font` (use the NL no-ligatures version)
- **ripgrep** (for Telescope live grep): `brew install ripgrep`
- **tree-sitter** (for tree sitter): `brew install tree-sitter`
- **Formatters/linters**: oxlint, oxfmt, prettier, eslint_d and cspell are resolved from each project's `node_modules/.bin`; stylua is installed via Mason (`:MasonInstall stylua`); gofmt ships with Go

## Structure

```
lua/
  plugins/              -- Plugin configs (one per file)
  lazy_init.lua         -- Lazy.nvim plugin manager bootstrap
  colorscheme.lua       -- Active colorscheme selection
  set.lua               -- Editor options
  remap.lua             -- Custom keybindings
  autocmds.lua          -- Autocommands (e.g. trim trailing whitespace)
scripts/
  update-plugins        -- Age-gated plugin updates (replaces :Lazy update)
plugin-first-seen.json  -- When this machine first saw each candidate commit
```

## Updating plugins

`:Lazy update` and `:Lazy sync` are disabled. lazy.nvim has no minimum-release-age
setting ([#2141](https://github.com/folke/lazy.nvim/issues/2141) is open), so updates
go through a script that only moves `lazy-lock.json` to commits that have been public
for at least two weeks -- the same idea as pnpm's `minimumReleaseAge`. That leaves a
window for a compromised release to be spotted and yanked before it lands here.

```sh
scripts/update-plugins            # observe, and show what is eligible to move
scripts/update-plugins --apply    # write the lockfile, then check plugins out
scripts/update-plugins --days 30  # override the minimum age
```

Plugins pinned by `tag`, `version`, `commit` or `pin` are skipped -- walking those back
by date would drag them off their pin. Review `git diff lazy-lock.json` and commit it.

`:Lazy install`, `:Lazy restore`, `:Lazy clean` and `:Lazy check` still work as normal.

Eligibility is based on when this machine first saw a commit, recorded in
`plugin-first-seen.json`, not on the commit's own date. Committer dates are set by
whoever made the commit, so they can't establish how long something has been public:
pushing a commit today stamped three weeks ago takes one environment variable. Every
run records what it sees, including dry runs, so the first run on a fresh checkout
updates nothing and starts the clock instead. The script also refuses anything that
isn't a fast-forward from the locked commit.

Because observation is what starts the clock, the effective delay is roughly the
interval between runs plus two weeks. That errs on the safe side.

Mason's npm packages get the same two-week window through `npm --before` (set in
`lua/plugins/lsp.lua`). Mason packages installed from a GitHub release or `go install`
have no equivalent knob. In practice the binaries that run against project code
(oxlint, oxfmt, cspell, prettier) come from the project's own `node_modules`, so the
coverage that matters most is whatever the project's package manager enforces.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/formatter installer |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics viewer |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting for tools without an LSP (cspell) |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk signs and actions |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Autocomplete (LSP, path, buffer) |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump/motion navigation |
| [arrow.nvim](https://github.com/otavioschwanck/arrow.nvim) | Bookmark files |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding popup after pressing a prefix |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history browser |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | lua_ls setup for editing this config |
| [cyberdream](https://github.com/scottmckendry/cyberdream.nvim) | Colorscheme |
| [oxocarbon](https://github.com/nyoom-engineering/oxocarbon.nvim) | Colorscheme (alt) |
| [rose-pine](https://github.com/rose-pine/neovim) | Colorscheme (alt) |

## Language Support

**LSP servers** (installed via Mason): `ts_ls` (TypeScript), `gopls` (Go), `eslint` and `oxlint` (JS/TS linting), `lua_ls` (Lua)

`eslint` and `oxlint` each require their own config file in the project before they attach, so they self-select per repo as projects migrate from one to the other. `oxlint` also provides `:LspOxlintFixAll`.

**Treesitter parsers**: JS/TS/TSX, Go, Lua, Python, Ruby, HTML, CSS, JSON, YAML, Markdown, Bash, and more -- see `lua/plugins/treesitter.lua` for the full list

**Formatters**: gofmt (Go), stylua (Lua) -- format on save enabled. Go also runs gopls `source.organizeImports` on save (adds missing imports, removes unused).

For JS/TS the chain is picked per project from the config files present: `oxlint --fix` + oxfmt when the repo has `.oxlintrc.json` / `.oxfmtrc.json`, otherwise eslint_d + prettier. The fixer runs before the formatter.

**Spell checking**: cspell runs via nvim-lint on read, write and leaving insert mode, but only in projects that have a cspell config. Diagnostics are `INFO` severity so they stay out of the statusline's error/warning counts. `<leader>aw` yanks the word under the cursor and opens the nearest `cspell.json` at its words list, ready to paste.

## Key Bindings

Leader key is `<Space>`.

### Navigation

| Key | Action |
|-----|--------|
| `<leader>pf` | Find files |
| `<C-p>` | Git files |
| `<leader>fb` | Search buffers |
| `<leader>ps` | Grep search |
| `<C-q>` | Persist Grep search results to quickfix list |
| `<leader>pws` | Grep word under cursor |
| `-` | Open file explorer (netrw) |
| `%` | New file (inside netrw) |
| `d` | New directory (inside netrw) |
| `R` | Rename file/directory (inside netrw) |
| `D` | Delete file/directory (inside netrw) |
| `<leader>vh` | Search help tags |
| `;` | Open Arrow file bookmarks |
| `b` | Open Arrow buffer bookmarks |
| `s` | Flash jump |
| `S` | Flash treesitter select |
| `<C-d` / `<C-u>` | Half page up / down |
| `<C-g>` | Show relative file path in command line |
| `1<C-g>` | Show absolute file path in command line |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `<C-o>` | Go back |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>ci` | Add missing imports (Go / TS) |
| `<leader>f` | Format buffer (conform, falls back to LSP) |
| `[d` / `]d` | Prev/next diagnostic (built-in) |
| `<leader>e` | Float diagnostics |

### Autocomplete (blink.cmp)

| Key | Action |
|-----|--------|
| `<C-space>` | Open menu / open docs if menu open |
| `<Tab>` | Accept selected item |
| `<C-n>` / `<C-p>` | Next/prev item |
| `<C-e>` | Dismiss menu |
| `<C-k>` | Toggle signature help |
| `<leader>ac` | Toggle auto-show menu (off by default) |

### Trouble

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>cs` | Symbols |
| `<leader>cl` | LSP defs/refs |
| `<leader>xQ` | Quickfix list |

### Git

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (Fugitive) |
| `s` | Stage file |
| `u` | Unstage file |
| `cc` | Commit |
| `gq` | Close status pane |
| `]h` / `[h` | Next/prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>gvo` | Diffview open |
| `<leader>gvp` | Diffview PR review (vs `origin/main`) |
| `<leader>gvc` | Diffview close |
| `<leader>gvh` | Diffview file history (current file) |
| `<leader>gvH` | Diffview file history (repo) |

#### Diffview merge conflict resolution

These are diffview's built-in, buffer-local keymaps (active inside the 3-way merge view):

| Key | Action |
|-----|--------|
| `<leader>co` | Choose OURS |
| `<leader>ct` | Choose THEIRS |
| `<leader>cb` | Choose BASE |
| `<leader>ca` | Choose ALL |
| `dx` | Delete conflict region |
| `]x` / `[x` | Next/prev conflict |

### Editing

| Key | Action |
|-----|--------|
| `J` / `K` (visual) | Move selection down/up |
| `<leader>y` | Yank to system clipboard |
| `<leader>p` | Paste over selection (preserve register) |
| `<leader>d` | Delete to void register |
| `<leader>s` | Search/replace word under cursor |
| `\\` | Toggle comments |

### Go (active in .go files only)

| Key | Action |
|-----|--------|
| `<leader>ee` | Insert `if err != nil { return err }` |
| `<leader>ea` | Insert `assert.NoError(err, "")` |
| `<leader>ef` | Insert `if err != nil { log.Fatalf(...) }` |
| `<leader>el` | Insert `if err != nil { .logger.Error(...) }` |

> **Note:** `<leader>e` (LSP float diagnostics) shares a prefix — Neovim will pause briefly before firing it.

### Global

| Key | Action |
|-----|--------|
| `<leader>ww` | Toggle word wrap |
| `<leader>dm` | Toggle dark/light mode |
| `<leader>cp` | Copy relative file path to clipboard |
| `<leader>aw` | Yank word under cursor, open the project's `cspell.json` at its words list |
| `<leader>u` | Toggle undotree |

Pressing `<leader>` (or any prefix) and pausing shows a which-key popup of available bindings.

## Notable Settings

- **Statusline**: left shows mode (color-coded by mode family), path, and `[+]` modified flag (yellow when unsaved); right shows branch, scroll percent, and colored diagnostic counts (`E:n` red, `W:n` yellow) when the buffer has errors or warnings
- **Indentation**: 4 spaces
- **Line numbers**: Relative + absolute
- **Color column**: 80
- **Persistent undo**: Enabled (`~/.vim/undodir`)
- **Swap/backup files**: Disabled
- **Scrolloff**: 8 lines
- **Search**: Incremental, smart case, no persistent highlight
- **Splits**: Open right and below
- **Trailing whitespace**: Auto-trimmed on save
