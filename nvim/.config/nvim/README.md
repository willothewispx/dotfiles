# Neovim config (lazy.nvim)

Minimal Lua configuration: **Tokyo Night**, **snacks.nvim** (dashboard), **neo-tree.nvim** (explorer), **telescope.nvim** (search), **toggleterm.nvim** (Codex CLI sidebar), **gitsigns.nvim**, **Neogit**, **diffview.nvim**, **todo-comments.nvim**, **Treesitter**, **native LSP** (`vim.lsp.config` / `vim.lsp.enable`), **nvim-cmp**, **which-key**. Leader: `,`.

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
| Search     | `lua/plugins/telescope.lua` (`<leader>ff`, `<leader>fg`) |
| AI         | `lua/plugins/ai.lua` (`<leader>a`) |
| Terminal   | `lua/plugins/toggleterm.lua` |
| Git        | `lua/plugins/git.lua` (`<leader>g`) |
| Todo       | `lua/plugins/todo-comments.lua` (`<leader>t`) |
| Dashboard  | `lua/plugins/snacks.lua` |
| Treesitter | `lua/plugins/treesitter.lua` |
| LSP / diag | `lua/plugins/lsp.lua`   |
| File ops   | `lua/plugins/lsp-file-operations.lua` |
| Completion | `lua/plugins/completion.lua` |
| Which-key  | `lua/plugins/which-key.lua` (`<leader>?`) |

`nvim-tree` is currently disabled, not removed, so it is easy to restore later.

Plugin-local `keys = { ... }` in each file keeps bindings next to the feature.

## Codex CLI

There is a toggleterm-powered sidebar integration for the local `codex` CLI:

- `<leader>ai` toggle Codex terminal
- `<leader>aI` focus Codex terminal
- `<leader>ab` focus the previous code window
- `<leader>al` open/focus Codex terminal and send the current file path as context

Inside the Codex terminal:

- `<Esc>` or `jk` leaves terminal-input mode
- `<C-h>` jumps back to the previous code window
- `<C-w>` enters normal window-navigation from terminal mode

## Optional: Mason

To install language servers from inside Neovim, you can add `williamboman/mason.nvim` and `mason-lspconfig` later; this setup intentionally stays minimal and uses only native LSP + `nvim-lspconfig` defaults.
