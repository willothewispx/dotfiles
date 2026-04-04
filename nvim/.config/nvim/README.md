# Neovim config (lazy.nvim)

Minimal Lua configuration: **Tokyo Night**, **lualine.nvim**, **snacks.nvim** (dashboard), **neo-tree.nvim** (explorer), **telescope.nvim** (search), **sidekick.nvim** (Codex CLI sidebar), **toggleterm.nvim** (floating terminals), **kulala.nvim** (`.http` requests), **gitsigns.nvim**, **Neogit**, **diffview.nvim**, **todo-comments.nvim**, **Treesitter**, **nvim-autopairs**, **rainbow-delimiters.nvim**, **native LSP** (`vim.lsp.config` / `vim.lsp.enable`), **nvim-cmp**, **which-key**. Leader: `,`.

## First run

1. Symlink or copy this directory to `~/.config/nvim` (or point your dotfiles manager here).
2. Start Neovim; **lazy.nvim** will bootstrap on first launch.
3. Run `:Lazy sync` to install plugins.
4. Install language servers so they are on your `$PATH` (this config does not install binaries). Examples:
   - `npm install -g typescript-language-server` (for `ts_ls`)
   - `npm install -g pyright`
   - Others: see each server’s install docs in `:help lspconfig-all` or the [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) server list.
5. Open a source file and check `:checkhealth vim.lsp` if something does not attach.

## Changing enabled servers

Edit the `servers` table in [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua), then restart Neovim (or `:lua vim.lsp.enable({...})` after adjusting config).

## Keymaps (where to edit)

| Area        | File                    |
|------------|-------------------------|
| Explorer   | `lua/plugins/neo-tree.lua` (`<leader>e`) |
| Search     | `lua/plugins/telescope.lua` (`<leader>ff`, `<leader>fg`, `<leader>ft`) |
| AI         | `lua/plugins/ai.lua` (`<leader>a`) |
| Terminal   | `lua/plugins/toggleterm.lua` |
| Statusline | `lua/plugins/lualine.lua` |
| HTTP       | `lua/plugins/kulala.lua` (`<leader>R`) |
| Sorting    | `lua/plugins/sort.lua` (`<leader>ls`) |
| Editing    | `lua/plugins/autopairs.lua`, `lua/plugins/rainbow-delimiters.lua` |
| Git        | `lua/plugins/git.lua` (`<leader>g`) |
| Todo       | `lua/plugins/todo-comments.lua` (`<leader>ft`, `<leader>tq`) |
| Dashboard  | `lua/plugins/snacks.lua` |
| Treesitter | `lua/plugins/treesitter.lua` |
| LSP / diag | `lua/plugins/lsp.lua`   |
| File ops   | `lua/plugins/lsp-file-operations.lua` |
| Completion | `lua/plugins/completion.lua` |
| Which-key  | `lua/plugins/which-key.lua` (`<leader>?`) |

`nvim-tree` is currently disabled, not removed, so it is easy to restore later.

Plugin-local `keys = { ... }` in each file keeps bindings next to the feature.

## Codex CLI

There is a Sidekick-powered sidebar integration for the local `codex` CLI:

- `<leader>ai` toggle Codex terminal
- `<leader>aI` focus Codex terminal
- `<leader>ab` focus the previous window
- `<leader>al` open/focus Codex terminal and send the current file path as context
- `<leader>as` select an installed AI CLI

Sidekick is configured in CLI-only mode. Next Edit Suggestions (NES) are disabled.

Codex session persistence is enabled through `tmux`, so hiding and reopening the sidebar should reconnect to the same Codex session.

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
