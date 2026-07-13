# Herdr Tab Picker Icons Design

## Goal

Make current-workspace picker rows align reliably and identify terminal, Neovim, and agent tabs at a glance.

## Row layout

Picker input uses fixed-width fields rendered before `fzf`:

```text
ICON  NAME                    STATUS
```

`fzf` filters against visible icon, name, and status while retaining tab ID as hidden selection data. Widths use display-cell-aware formatting so all name and status columns start at consistent terminal cells.

## Icon selection

- Default: Nerd Font terminal glyph.
- Neovim: Nerd Font Neovim glyph when any pane in that tab has foreground process name `nvim` or `vim`.
- Known agent labels: stable distinct Nerd Font marks for Codex/ChatGPT, Grok, and OpenCode.
- Unknown labels: terminal glyph.

Agent icons are intentionally distinct marks, not claimed official company logos: Nerd Fonts does not provide confirmed branded ChatGPT or Grok glyphs. This keeps terminal rendering portable and avoids fake branding.

## Live process detection

Script calls `herdr pane list --workspace "$HERDR_ACTIVE_WORKSPACE_ID"`, then calls `herdr pane process-info --pane <pane_id>` for panes in that workspace. A tab is Neovim if any returned foreground process has `name` equal to `nvim` or `vim`.

Process-info failures propagate. Empty pane lists are valid and leave every tab at its label-derived/default icon.

## Error handling

Required `jq`, `fzf`, Herdr CLI, malformed JSON, or process-info failures exit non-zero. Escape still cancels picker successfully without focusing another tab.

## Testing

Behavior test covers fixed column formatting, label icon mapping, Neovim detection from pane process metadata, fallback terminal icon, selection, cancellation, and error propagation. Deployment test continues verifying Stow exposes executable script at Herdr runtime path.
