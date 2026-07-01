# Tree-sitter Manager Migration Design

## Goal

Replace the Rocks/LuaRocks Tree-sitter parser setup with
`romus204/tree-sitter-manager.nvim`, managed by `lazy.nvim`.

## Architecture

Tree-sitter manager becomes the sole parser installer and query manager.
Neovim supplies its bundled parsers; the manager installs other missing parsers
when their filetype is first opened.

The plugin configuration uses:

```lua
require("tree-sitter-manager").setup({
  auto_install = true,
  noauto_install = {
    "c",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
  },
})
```

There is no `ensure_installed` list. Parser availability follows actual file
usage instead of maintaining a duplicate inventory.

## Changes

- Delete `lua/config/rocks.lua` and `rocks.toml`.
- Remove Rocks initialization and runtime-path refreshes from `init.lua`.
- Remove Rocks-specific settings from `lua/config/lazy.lua`.
- Add `lua/plugins/treesitter.lua` containing the lazy.nvim plugin spec and the
  approved setup.
- Update `README.md` to describe the new dependency, first-run behavior, and
  `:TSManager`, `:TSInstall`, `:TSUninstall`, and `:TSUpdate` commands.
- Refresh `lazy-lock.json` through lazy.nvim.

## Runtime Flow

1. lazy.nvim loads `tree-sitter-manager.nvim`.
2. The manager uses Neovim's bundled parsers for the seven excluded languages.
3. Opening another supported filetype triggers installation when its parser is
   missing.
4. The manager starts Tree-sitter highlighting and supplies its bundled queries.
5. Installation or compilation errors remain visible; no fallback suppresses
   them.

## Requirements

- Neovim 0.12 or newer.
- `tree-sitter` CLI available on `PATH`.
- Git and a C compiler.

The current machine satisfies the Neovim and Tree-sitter CLI requirements.

## Verification

- Start Neovim headlessly with the migrated configuration and fail on startup
  errors.
- Confirm `:TSManager` exists.
- Confirm the plugin reports healthy dependencies.
- Open a file using a bundled parser and verify Tree-sitter highlighting starts
  without an install.
- In isolated Neovim data directories, open a supported non-bundled filetype and
  verify automatic installation, parser attachment, and highlighting.
- Search the repository for stale Rocks/LuaRocks references.

## Non-goals

- No eager parser inventory.
- No custom parser aliases or repositories.
- No fallback parser installer.
- No deletion of existing Rocks data outside this configuration repository.
