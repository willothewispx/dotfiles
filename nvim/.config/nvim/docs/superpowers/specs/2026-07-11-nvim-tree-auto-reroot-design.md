# nvim-tree Automatic Re-rooting Design

## Goal

Keep nvim-tree synchronized with the active file when navigation leaves the startup project, while restoring the startup project root when navigation returns.

## Behavior

- Entering a file below the current tree root keeps the existing root and focuses that file.
- Entering a readable file outside the current tree root changes the root using nvim-tree's built-in root selection.
- A file below Neovim's startup root selects the startup root when `prefer_startup_root` is enabled.
- A file outside the startup root falls back to Neovim's current working directory, a configured preferred root, or the file's containing directory according to nvim-tree's upstream behavior.
- The behavior applies to every eligible `BufEnter`, including LSP definition jumps and jump-list navigation.

## Configuration

Use nvim-tree's supported configuration only:

```lua
prefer_startup_root = true,
update_focused_file = {
  enable = true,
  update_root = {
    enable = true,
  },
},
```

Keep existing `sync_root_with_cwd`, `respect_buf_cwd`, rendering, view, and mappings unchanged. Do not add custom LSP handlers or root-history state.

## Verification

- Config test asserts `prefer_startup_root` is enabled.
- Config test asserts focused-file tracking and nested root updating are enabled.
- Config test continues to ensure key callbacks do not force an independent root-update policy.
- Run the Lua config test headlessly.
- Manually verify: open project file, jump to external vendor definition, observe vendor context, jump back, observe startup project root.

