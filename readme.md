# Neovim Configuration

A minimal, Lua-based Neovim configuration focused on TypeScript and Go development.

## Prerequisites

- **Neovim**: `brew install neovim`
- **Nerd Font**: `brew install --cask font-jetbrains-mono-nerd-font` (use the NL no-ligatures version)
- **ripgrep** (for Telescope live grep): `brew install ripgrep`
- **tree-sitter-cli** (for tree sitter): `brew install tree-sitter`

## Structure

```
lua/
  plugins/              -- Plugin configs (one per file)
  lazy_init.lua         -- Lazy.nvim plugin manager bootstrap
  colorscheme.lua       -- Active colorscheme selection
  set.lua               -- Editor options
  remap.lua             -- Custom keybindings
  autocmds.lua          -- Autocommands (e.g. trim trailing whitespace)
```

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
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk signs and actions |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Autocomplete (LSP, path, buffer) |
| [flash.nvim](https://github.com/folke/flash.nvim) | Jump/motion navigation |
| [arrow.nvim](https://github.com/otavioschwanck/arrow.nvim) | Bookmark files |
| [cyberdream](https://github.com/scottmckendry/cyberdream.nvim) | Colorscheme |
| [oxocarbon](https://github.com/nyoom-engineering/oxocarbon.nvim) | Colorscheme (alt) |
| [rose-pine](https://github.com/rose-pine/neovim) | Colorscheme (alt) |

## Language Support

**LSP servers** (installed via Mason): `ts_ls` (TypeScript), `gopls` (Go), `eslint` (JS/TS linting)

**Treesitter parsers**: JavaScript, TypeScript, TSX, Go, HTML, CSS, JSON, Lua, Vim

**Formatters**: prettier + eslint_d (JS/TS), gofmt (Go) -- format on save enabled

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
| `<leader>ex` | Open file explorer (netrw) |
| `<leader>vh` | Search help tags |
| `;` | Open Arrow file bookmarks |
| `b` | Open Arrow buffer bookmarks |
| `s` | Flash jump |
| `S` | Flash treesitter select |
| `<C-d` / `<C-u>` | Half page up / down |

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
| `<leader>f` | Format buffer |
| `[d` / `]d` | Prev/next diagnostic |
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
| `<leader>dvo` | Diffview open |
| `<leader>dvc` | Diffview close |
| `<leader>dvh` | Diffview file history (current file) |
| `<leader>dvH` | Diffview file history (repo) |

### Editing

| Key | Action |
|-----|--------|
| `J` / `K` (visual) | Move selection down/up |
| `<leader>y` | Yank to system clipboard |
| `<leader>p` | Paste over selection (preserve register) |
| `<leader>d` | Delete to void register |
| `<leader>s` | Search/replace word under cursor |
| `\\` | Toggle comments |

### Global

| Key | Action |
|-----|--------|
| `<leader>ww` | Toggle word wrap |
| `<leader>dm` | Toggle dark/light mode |
| `<leader>cp` | Copy relative file path to clipboard |

## Notable Settings

- **Indentation**: 4 spaces
- **Line numbers**: Relative + absolute
- **Color column**: 80
- **Persistent undo**: Enabled (`~/.vim/undodir`)
- **Swap/backup files**: Disabled
- **Scrolloff**: 8 lines
- **Search**: Incremental, smart case, no persistent highlight
- **Splits**: Open right and below
- **Trailing whitespace**: Auto-trimmed on save
