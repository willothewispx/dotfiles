# Neovim config (lazy.nvim)

Minimal Lua configuration: **Tokyo Night**, **bufferline.nvim**, **lualine.nvim**, **snacks.nvim** (dashboard + picker + lazygit), **neo-tree.nvim** (explorer), **grug-far.nvim** (find and replace), **supermaven-nvim** (AI completion), **toggleterm.nvim** (floating terminals), **kulala.nvim** (`.http` requests), **gitsigns.nvim**, **diffview.nvim**, **trouble.nvim**, **todo-comments.nvim**, **rocks.nvim Tree-sitter**, **nvim-autopairs**, **nvim-surround**, **rainbow-delimiters.nvim**, **native LSP** (`vim.lsp.config` / `vim.lsp.enable`), **nvim-cmp**, **which-key**. Leader: `,`.

## First run

1. Symlink or copy this directory to `~/.config/nvim` (or point your dotfiles manager here).
2. Start Neovim; **lazy.nvim** and **rocks.nvim** will bootstrap on first launch.
3. Run `:Lazy sync` to install plugins.
4. Run `:Rocks sync` once to install `rocks-treesitter.nvim` and the configured parser/query rocks.
5. For Supermaven, run `:SupermavenUseFree` the first time it prompts for an account tier.
6. Install language servers so they are on your `$PATH` (this config does not install binaries). Examples:
   - `npm install -g typescript-language-server` (for `ts_ls`)
   - `npm install -g pyright`
   - Others: see each server’s install docs in `:help lspconfig-all` or the [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) server list.
7. Open a source file and check `:checkhealth vim.lsp` if something does not attach.

## Changing enabled servers

Edit the `servers` table in [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua), then restart Neovim (or `:lua vim.lsp.enable({...})` after adjusting config).

## Keymaps (where to edit)

| Area        | File                    |
|------------|-------------------------|
| Explorer   | `lua/plugins/neo-tree.lua` (`<leader>e`) |
| Search     | `lua/plugins/snacks.lua` (`<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fs`, `<leader>fh`) |
| Replace    | `lua/plugins/grug-far.lua` (`<leader>fr`, `<leader>fR`) |
| AI completion | `lua/plugins/supermaven.lua` (`<Tab>`, `<C-j>`, `<C-]>`) |
| Buffers    | `lua/plugins/bufferline.lua` (`[b`, `]b`, `<leader>bp`) |
| Terminal   | `lua/plugins/toggleterm.lua` |
| Statusline | `lua/plugins/lualine.lua` |
| HTTP       | `lua/plugins/kulala.lua` (`<leader>R`) |
| Trouble    | `lua/plugins/trouble.lua` (`<leader>x`) |
| Sorting    | `lua/plugins/sort.lua` (`<leader>ls`) |
| Editing    | `lua/plugins/autopairs.lua`, `lua/plugins/surround.lua`, `lua/plugins/rainbow-delimiters.lua` |
| Git        | `lua/plugins/git.lua`, `lua/plugins/snacks.lua` (`<leader>g`) |
| Quickfix   | `lua/config/options.lua` (`<leader>cn`, `<leader>cp`) |
| Todo       | `lua/plugins/todo-comments.lua` (`<leader>ft`, `]t`, `[t`) |
| Dashboard  | `lua/plugins/snacks.lua` |
| Treesitter | `lua/config/rocks.lua`, `rocks.toml` |
| LSP / diag | `lua/plugins/lsp.lua`   |
| File ops   | `lua/plugins/lsp-file-operations.lua` |
| Completion | `lua/plugins/completion.lua` |
| Which-key  | `lua/plugins/which-key.lua` (`<leader>?`) |

`nvim-tree` is currently disabled, not removed, so it is easy to restore later.

Plugin-local `keys = { ... }` in each file keeps bindings next to the feature.

## Treesitter

Treesitter parser/query management is handled by `rocks.nvim` and `rocks-treesitter.nvim`; regular plugins remain managed by `lazy.nvim`.

- Parser rocks live in `rocks.toml`
- `:Rocks sync` installs the committed parser/query set
- `:Rocks update` updates all rocks-managed parser packages
- `:Rocks update tree-sitter-<lang>` updates one parser package

`rocks-treesitter.nvim` owns auto-highlighting for the configured language list. It is configured with `treesitter.auto_install = "prompt"` so opening a file will not silently perform network installs.

## Search

Search now uses `snacks.nvim` picker instead of Telescope:

- `<leader>ff` find files
- `<leader>fF` find files, including `.gitignore`d files
- `<leader>fg` grep in files
- `<leader>fG` grep in files, including `.gitignore`d files
- `<leader>fb` find buffers
- `<leader>fs` search lines in the current buffer
- `<leader>fh` search help tags
- `<leader>ft` search todo comments
- `<leader>fr` find and replace across the current project
- `<leader>fR` find and replace in the current file
- `<leader>gg` lazygit
- `<leader>gl` lazygit log
- `<leader>gf` lazygit file log
- `<leader>gb` lazygit branches
- `<leader>gs` lazygit stash

The picker supports fzf search syntax, field searches, and picker arguments after `--`.
The ignored-file variants use Snacks' `ignored = true`; `.git` itself stays excluded by the shared picker config.

- `foo` fuzzy match
- `foo bar` both terms must match
- `'foo` exact match
- `'foo'` exact word-boundary match
- `^foo` prefix match
- `foo$` suffix match
- `!foo` exclude matches containing `foo`
- `!^foo` exclude matches starting with `foo`
- `!foo$` exclude matches ending with `foo`
- `foo | bar` OR query
- `file:lua$ 'function` match exact `function` in files ending in `lua`
- `file:README ^install` match entries in files whose path contains `README`, with text starting with `install`
- `main.ts:120` or `main.ts:120:8` jump directly to file position
- `foo -- -e=lua` grep only Lua files
- `foo -- -g=*.ts` grep only TypeScript files
- `foo -- -g=*.{ts,tsx}` grep only TS/TSX files
- `init -- -e=lua` in `<leader>ff` narrows file search to Lua files

## Find and Replace

Find and replace uses [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim). It opens an editable search buffer backed by `rg`; searches update as you type, and replacements are only written when you run the replace action.

Inside one file:

1. Open the file you want to edit.
2. Press `<leader>fR`.
3. Fill in `Search:` with the text or regex to find.
4. Fill in `Replace:` with the replacement text.
5. Review the diff in the results area.
6. In normal mode inside the grug-far buffer, press `<localleader>r` to apply the replacement. With this config, that is `,r`.

Project-wide:

1. Press `<leader>fr`.
2. Fill in `Search:` and `Replace:`.
3. Leave `Paths:` empty to search from the current working directory, or set it to a narrower path like `lua/`, `README.md`, or multiple paths on separate lines.
4. Optionally set `Files Filter:` to a glob like `*.lua` or `*.md`.
5. Optionally add `Flags:` such as `--fixed-strings` for literal text or `--case-sensitive` for exact casing.
6. Review the diff, delete result lines you do not want to apply, then press `<localleader>r` (`,r`) to replace.

Useful commands:

- `:GrugFar` open project find and replace
- `:GrugFarWithin` search and replace within a visual selection range
- `:checkhealth grug-far` diagnose missing `rg` or plugin issues

## Explorer Search

Inside Neo-tree:

- `F` search files in the hovered folder
- `G` grep in the hovered folder

If the cursor is on a file, both mappings use that file's parent folder.

## Floating Terminal

There is also a general floating shell terminal:

- `<leader>tt` toggle floating terminal
- `<leader>tT` toggle second floating terminal
- `<leader>tb` focus the previous code window

Inside the floating terminal:

- `<Esc>` or `jk` leaves terminal-input mode
- `<C-h>` jumps back to the previous code window
- `<C-w>` enters normal window-navigation from terminal mode

## HTTP Requests

For `.http` and `.rest` files, Kulala is configured with:

- `<leader>Rs` send request under cursor
- `<leader>Ra` send all requests
- `<leader>Rb` open scratchpad
- `<leader>Re` select environment

## Optional: Mason

To install language servers from inside Neovim, you can add `williamboman/mason.nvim` and `mason-lspconfig` later; this setup intentionally stays minimal and uses only native LSP + `nvim-lspconfig` defaults.
