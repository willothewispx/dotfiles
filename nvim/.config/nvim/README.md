# Neovim config (lazy.nvim)

Minimal Lua configuration: **Tokyo Night**, **bufferline.nvim**, **lualine.nvim**, **snacks.nvim** (dashboard + picker + lazygit), **nvim-tree.lua** (explorer), **grug-far.nvim** (find and replace), **supermaven-nvim** (AI completion), **tabterm.nvim** (tab-scoped terminal workspace), **kulala.nvim** (`.http` requests), **gitsigns.nvim**, **codediff.nvim**, **trouble.nvim**, **todo-comments.nvim**, **tree-sitter-manager.nvim**, **nvim-autopairs**, **nvim-surround**, **rainbow-delimiters.nvim**, **native LSP** (`vim.lsp.config` / `vim.lsp.enable`), **nvim-cmp**, **which-key**. Leader: `,`.

## First run

1. Symlink or copy this directory to `~/.config/nvim` (or point your dotfiles manager here).
2. Install `tree-sitter`, `git`, and a working C compiler so parser builds can succeed.
3. Start Neovim; **lazy.nvim** will bootstrap on first launch.
4. Run `:Lazy sync` to install plugins.
5. Open files normally. Neovim 0.12 uses its bundled Tree-sitter parsers for `c`, `lua`, `markdown`, `markdown_inline`, `query`, `vim`, and `vimdoc`; `tree-sitter-manager.nvim` installs other missing parsers the first time you open a supported filetype.
6. For Supermaven, run `:SupermavenUseFree` the first time it prompts for an account tier.
7. Install language servers so they are on your `$PATH` (this config does not install binaries). Examples:
   - `npm install -g typescript-language-server` (for `ts_ls`)
   - `npm install -g pyright`
   - `brew install texlab latexindent` (for LaTeX)
   - Others: see each server’s install docs in `:help lspconfig-all` or the [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) server list.
8. Open a source file and check `:checkhealth vim.lsp` if something does not attach.

## Changing enabled servers

Edit the `servers` table in [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua), then restart Neovim (or `:lua vim.lsp.enable({...})` after adjusting config).

## Keymaps (where to edit)

| Area        | File                    |
|------------|-------------------------|
| Explorer   | `lua/plugins/file-tree.lua` (`<leader>e`, `<leader>E`) |
| Search     | `lua/plugins/snacks.lua` (`<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fs`, `<leader>fh`) |
| Replace    | `lua/plugins/grug-far.lua` (`<leader>fr`, `<leader>fR`) |
| AI completion | `lua/plugins/supermaven.lua` (`<Tab>`, `<C-j>`, `<C-]>`) |
| Buffers    | `lua/plugins/bufferline.lua` (`[b`, `]b`, `<leader>bp`) |
| Terminal   | `lua/plugins/tabterm.lua` |
| Statusline | `lua/plugins/lualine.lua` |
| HTTP       | `lua/plugins/kulala.lua` (`<leader>R`) |
| LaTeX      | `lua/plugins/latex.lua` (`<leader>L`) |
| Trouble    | `lua/plugins/trouble.lua` (`<leader>x`) |
| Sorting    | `lua/plugins/sort.lua` (`<leader>ls`) |
| Editing    | `lua/plugins/autopairs.lua`, `lua/plugins/surround.lua`, `lua/plugins/rainbow-delimiters.lua` |
| Git        | `lua/plugins/git.lua`, `lua/plugins/snacks.lua` (`<leader>g`) |
| Quickfix   | `lua/config/options.lua` (`<leader>cn`, `<leader>cp`) |
| Todo       | `lua/plugins/todo-comments.lua` (`<leader>ft`, `]t`, `[t`) |
| Dashboard  | `lua/plugins/snacks.lua` |
| Treesitter | `lua/plugins/treesitter.lua` |
| LSP / diag | `lua/plugins/lsp.lua`   |
| File ops   | `lua/plugins/lsp-file-operations.lua` |
| Completion | `lua/plugins/completion.lua` |
| Which-key  | `lua/plugins/which-key.lua` (`<leader>?`) |

Plugin-local `keys = { ... }` in each file keeps bindings next to the feature.

## Treesitter

Tree-sitter parser and query management is handled by [tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim), loaded by `lazy.nvim`.

- `:TSManager` opens the manager UI
- `:TSInstall <lang>` installs one parser
- `:TSUninstall <lang>` removes one parser
- `:TSUpdate` updates installed parsers and queries

This config enables automatic installation for supported languages that are not already bundled with Neovim 0.12. The bundled parsers for `c`, `lua`, `markdown`, `markdown_inline`, `query`, `vim`, and `vimdoc` are excluded from manager installs to avoid duplicate parser copies.

## LaTeX

LaTeX editing uses VimTeX with MacTeX's `latexmk`, PDF Expert for PDF viewing, Texlab for LSP features, and Tree-sitter parsers for LaTeX and BibTeX.

- `<leader>Lb` compile
- `<leader>Lv` view PDF
- `<leader>Lt` open table of contents
- `<leader>Lo` open compiler output
- `<leader>Ls` show status
- `<leader>Lk` stop compiler
- `<leader>Lc` clean build artifacts

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

## Explorer

`nvim-tree` uses its defaults plus two global mappings:

- `<leader>e` toggle tree and reveal current file
- `<leader>E` focus tree and reveal current file

Inside `nvim-tree`, notable defaults include:

- `r` rename file or folder
- `Y` copy relative path
- `gy` copy absolute path
- `H` toggle dotfiles
- `I` toggle gitignored files

## Terminal Workspace

There is also a tab-scoped floating terminal workspace:

- `<leader>tt` toggle the current tab's terminal workspace
- `<leader>tT` create a new shell in the workspace
- `<leader>tc` create a one-shot command terminal

Inside the terminal workspace:

- `q` hides the workspace and restores editor focus
- `<C-h>` focuses the terminal sidebar from the panel
- `l` or `<C-l>` focuses the panel from the sidebar
- `i` / `a` insert a shell before / after the selected terminal
- `ci` / `ca` insert a command terminal before / after the selected terminal
- `r` renames the selected terminal
- `d` deletes the selected terminal

## HTTP Requests

For `.http` and `.rest` files, Kulala is configured with:

- `<leader>Rs` send request under cursor
- `<leader>Ra` send all requests
- `<leader>Rb` open scratchpad
- `<leader>Re` select environment

## Optional: Mason

To install language servers from inside Neovim, you can add `williamboman/mason.nvim` and `mason-lspconfig` later; this setup intentionally stays minimal and uses only native LSP + `nvim-lspconfig` defaults.
