# nvim-treesitter Return Design

## Goal

Replace `romus204/tree-sitter-manager.nvim` with the revived
`nvim-treesitter/nvim-treesitter` main branch while preserving automatic parser
installation and Tree-sitter highlighting.

## Architecture

`nvim-treesitter` becomes the sole parser and query manager. It loads eagerly,
as required upstream, and lazy.nvim runs `:TSUpdate` after plugin installation
or updates so parsers remain compatible with the plugin's queries.

Parser management uses a hybrid policy:

- A core parser inventory is installed proactively for languages supported by
  this configuration.
- Opening another supported filetype installs its missing parser automatically.
- Unsupported filetypes remain untouched.

Tree-sitter behavior stays separated into small modules: the lazy.nvim plugin
spec owns plugin lifecycle, while parser policy owns language resolution,
installation, and highlighting activation.

## Core Parsers

The guaranteed inventory covers the configured editing stack:

- Bash
- BibTeX and LaTeX
- CSS, HTML, JavaScript, TypeScript, and TSX
- Dockerfile
- Go, Go modules, and Go sums
- HTTP
- JSON and YAML
- Lua
- Markdown and Markdown inline
- Python
- Query, Vim, and Vimdoc

These parsers are managed together with their matching nvim-treesitter queries,
including languages for which Neovim bundles a parser. This avoids mixing
plugin queries with a parser revision outside the plugin's supported set.

## Runtime Flow

1. lazy.nvim loads `nvim-treesitter` during startup.
2. Configuration requests installation of missing core parsers asynchronously.
3. On `FileType`, parser policy maps the buffer filetype to its Tree-sitter
   language.
4. If the parser is available, highlighting starts immediately for that buffer.
5. If an officially supported parser is missing, nvim-treesitter installs it.
6. After successful installation, highlighting starts when the buffer is still
   valid and still uses the same language.
7. Installation failures remain visible; no fallback installer or swallowed
   error hides them.

Concurrent requests for the same missing parser must share one installation so
opening several matching buffers does not start duplicate builds.

## Features

Tree-sitter highlighting and language injections are enabled. Tree-sitter folds
remain unchanged, and experimental Tree-sitter indentation remains disabled.

The plugin continues to expose `:TSInstall`, `:TSUninstall`, and `:TSUpdate`.
The manager-specific `:TSManager` command is removed.

## Documentation Changes

Update `README.md` to:

- name `nvim-treesitter` instead of `tree-sitter-manager.nvim`;
- describe proactive core installation and automatic installation on file open;
- remove `:TSManager` documentation;
- retain current Neovim, Tree-sitter CLI, compiler, curl, and tar requirements;
- explain that `:TSUpdate` runs through lazy.nvim after plugin updates.

## Verification

- Start Neovim headlessly and fail on configuration errors.
- Confirm `:TSInstall`, `:TSUninstall`, and `:TSUpdate` exist.
- Confirm manager-only `:TSManager` no longer exists.
- Verify core parser bootstrap requests the approved inventory.
- Open a Lua buffer and verify Tree-sitter highlighting attaches.
- In isolated Neovim data directories, open a supported non-core filetype and
  verify one automatic parser installation and later highlighting attachment.
- Open multiple buffers for one missing parser and verify installation is
  deduplicated.
- Run `:checkhealth nvim-treesitter` and inspect failures rather than masking
  them.
- Search the repository for stale `tree-sitter-manager.nvim` references.

## Requirements

- Neovim 0.12 or newer.
- `tree-sitter` CLI 0.26.1 or newer, installed outside npm.
- `curl`, `tar`, and a working C compiler on `PATH`.

The current machine satisfies these requirements with Neovim 0.12.3 and
Tree-sitter CLI 0.26.9.

## Non-goals

- No Tree-sitter textobjects.
- No Tree-sitter folding or experimental indentation changes.
- No custom parser repositories or aliases.
- No fallback parser manager.
- No removal of parser data outside this repository.
