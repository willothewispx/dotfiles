# Neovim config (lazy.nvim)

Minimal Lua configuration: **Tokyo Night**, **nvim-tree**, **native LSP** (`vim.lsp.config` / `vim.lsp.enable`), **nvim-cmp**, **which-key**. Leader: `,`.

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
| File tree  | `lua/plugins/file-tree.lua` (`<leader>e`) |
| LSP / diag | `lua/plugins/lsp.lua`   |
| Completion | `lua/plugins/completion.lua` |
| Which-key  | `lua/plugins/which-key.lua` (`<leader>?`) |

Plugin-local `keys = { ... }` in each file keeps bindings next to the feature.

## Optional: Mason

To install language servers from inside Neovim, you can add `williamboman/mason.nvim` and `mason-lspconfig` later; this setup intentionally stays minimal and uses only native LSP + `nvim-lspconfig` defaults.
