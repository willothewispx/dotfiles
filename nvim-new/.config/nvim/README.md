# Neovim 0.11 minimal config (mini.nvim + mini.deps + LSP)

This setup uses `mini.nvim` with `mini.deps` as the package manager, LSP via `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig`, Catppuccin Mocha theme, and `mini.pick` for fuzzy finding.

## Install

1. Symlink the config:

```bash
mkdir -p ~/.config
ln -sfn ~/dotfiles/nvim-new/.config/nvim ~/.config/nvim
```

2. Start Neovim:

```bash
nvim
```

`mini.deps` will bootstrap and install plugins automatically on first start.

## Language servers

- Open `:Mason` to install servers, DAPs, or formatters.
- `lua_ls`, `gopls`, and `ts_ls` are ensured by default.
- To add more servers, update `lua/config/lsp.lua` under `ensure_installed` and the setup loop.

## Theme

- Default theme is Catppuccin Mocha.
- Change flavor in `lua/config/ui.lua`:

```lua
require('catppuccin').setup({ flavour = 'latte' }) -- or 'frappe' | 'macchiato' | 'mocha'
vim.cmd.colorscheme('catppuccin-latte')
```

## Keymaps

- Leader: `,`
- Clear search: `<Esc>`
  
- Windows: `<C-h/j/k/l>`
- mini.pick:
  - Files: `<leader>ff`
  - Live grep: `<leader>fg`
  - Buffers: `<leader>fb`
- File tree: `<leader>e`

## Notes

- Treesitter: manage parsers with `:TSUpdate`.
- Why the LSP trio?
  - `nvim-lspconfig`: configures Neovim's built-in LSP client per server
  - `mason.nvim`: installs external LSP binaries locally
  - `mason-lspconfig`: bridges Mason servers to lspconfig names/paths and supports `ensure_installed`

## Optional additions

- Completion: `blink.cmp` (or `nvim-cmp`); augment LSP capabilities in `lsp.lua`.
- Formatting: `conform.nvim`.
- UX: `which-key.nvim`.
- Git: `gitsigns.nvim`.
- Terminal: `toggleterm.nvim`.


