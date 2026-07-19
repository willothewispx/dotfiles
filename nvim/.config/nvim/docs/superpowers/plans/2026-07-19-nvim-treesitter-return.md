# nvim-treesitter Return Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `tree-sitter-manager.nvim` with revived `nvim-treesitter` while guaranteeing core parsers, automatically installing other supported parsers, and enabling highlighting safely.

**Architecture:** A pure policy module owns parser inventory, installation deduplication, and buffer attachment decisions. A thin Neovim adapter translates that policy into `nvim-treesitter` and Neovim APIs; the lazy.nvim plugin spec owns only plugin lifecycle.

**Tech Stack:** Neovim 0.12.3, LuaJIT, lazy.nvim, `nvim-treesitter/nvim-treesitter` main, Tree-sitter CLI 0.26.9.

## Global Constraints

- Neovim 0.12 or newer.
- `tree-sitter` CLI 0.26.1 or newer, installed outside npm.
- `curl`, `tar`, and a working C compiler must be on `PATH`.
- Load `nvim-treesitter` eagerly and run `:TSUpdate` after plugin installation or update.
- Enable Tree-sitter highlighting and injections; do not enable Tree-sitter folds or experimental indentation.
- Keep each code file below 300 lines and avoid nonessential comments.
- Do not add a fallback parser manager or suppress parser installation errors.
- Preserve unrelated worktree changes.

---

## File Structure

- Create `lua/config/treesitter_policy.lua`: pure parser inventory and installation/attachment state machine.
- Create `lua/config/treesitter.lua`: production adapter for Neovim and `nvim-treesitter` APIs.
- Modify `lua/plugins/treesitter.lua`: eager lazy.nvim plugin spec and `:TSUpdate` build hook.
- Temporarily create `tests/treesitter_policy_spec.lua`: dependency-free policy behavior tests run inside headless Neovim, then delete before final commit.
- Temporarily create `tests/treesitter_plugin_spec.lua`: plugin-spec regression test, then delete before final commit.
- Temporarily create `tests/treesitter_e2e.lua`: isolated real-parser installation and highlighting test, then delete before final commit.
- Modify `README.md`: new ownership, lifecycle, commands, and prerequisites.
- Modify `lazy-lock.json`: replace manager lock entry through `:Lazy sync`.

### Task 1: Parser Policy

**Files:**
- Create: `tests/treesitter_policy_spec.lua`
- Create: `lua/config/treesitter_policy.lua`

**Interfaces:**
- Produces: `require("config.treesitter_policy").core_parsers: string[]`
- Produces: `require("config.treesitter_policy").new(adapter): TreesitterPolicy`
- Consumes adapter methods: `is_managed(language): boolean`, `is_available(language): boolean`, `language_for_filetype(filetype): string?`, `install(languages, on_complete): nil`, `attach(buffer, language): boolean`, and `buffer_uses_language(buffer, language): boolean`.
- Produces policy methods: `bootstrap(): nil` and `open(buffer, filetype): nil`.

- [ ] **Step 1: Write failing policy tests**

Create `tests/treesitter_policy_spec.lua`:

```lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local function equal(actual, expected, message)
  if not vim.deep_equal(actual, expected) then
    error((message or "values differ") .. "\nexpected: " .. vim.inspect(expected) .. "\nactual: " .. vim.inspect(actual))
  end
end

local function new_adapter(options)
  local state = {
    attached = {},
    buffers = options.buffers or {},
    installs = {},
    loadable = options.loadable or {},
    managed = options.managed or {},
  }

  local adapter = {
    is_managed = function(language)
      return state.managed[language] == true
    end,
    is_available = function(language)
      return options.available[language] == true
    end,
    language_for_filetype = function(filetype)
      return options.languages[filetype]
    end,
    install = function(languages, on_complete)
      table.insert(state.installs, { languages = vim.deepcopy(languages), complete = on_complete })
    end,
    attach = function(buffer, language)
      if not state.loadable[language] then
        return false
      end
      table.insert(state.attached, { buffer = buffer, language = language })
      return true
    end,
    buffer_uses_language = function(buffer, language)
      return options.languages[state.buffers[buffer]] == language
    end,
  }

  return adapter, state
end

local Policy = require("config.treesitter_policy")

local all_managed = {}
for _, language in ipairs(Policy.core_parsers) do
  all_managed[language] = true
end
all_managed.python = nil

local adapter, state = new_adapter({
  available = { lua = true, python = true },
  buffers = { [1] = "python", [2] = "python" },
  languages = { lua = "lua", python = "python" },
  loadable = {},
  managed = all_managed,
})
local policy = Policy.new(adapter)

policy.bootstrap()
equal(#state.installs, 1, "bootstrap should make one batched install")
equal(state.installs[1].languages, { "python" }, "bootstrap should request missing core parsers")

policy.open(1, "python")
policy.open(2, "python")
equal(#state.installs, 1, "pending core install should be shared by all buffers")

state.loadable.python = true
state.installs[1].complete()
equal(state.attached, {
  { buffer = 1, language = "python" },
  { buffer = 2, language = "python" },
}, "all waiting buffers should attach after install")

adapter, state = new_adapter({
  available = { lua = true },
  buffers = { [3] = "lua" },
  languages = { lua = "lua", unknown = "unknown" },
  loadable = { lua = true },
  managed = {},
})
policy = Policy.new(adapter)
policy.open(3, "lua")
policy.open(4, "unknown")
equal(state.attached, { { buffer = 3, language = "lua" } }, "loadable parsers should attach immediately")
equal(#state.installs, 0, "unsupported parsers should not install")

adapter, state = new_adapter({
  available = { python = true },
  buffers = { [5] = "python", [6] = "python" },
  languages = { lua = "lua", python = "python" },
  loadable = {},
  managed = {},
})
policy = Policy.new(adapter)
policy.open(5, "python")
policy.open(6, "python")
equal(#state.installs, 1, "auto-install should be deduplicated")

state.buffers[5] = "lua"
state.loadable.python = true
state.installs[1].complete()
equal(state.attached, { { buffer = 6, language = "python" } }, "changed buffers should not attach stale parsers")

print("treesitter policy tests passed")
```

- [ ] **Step 2: Run policy tests and verify failure**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_policy_spec.lua
```

Expected: nonzero exit with `module 'config.treesitter_policy' not found`.

- [ ] **Step 3: Implement pure parser policy**

Create `lua/config/treesitter_policy.lua`:

```lua
local M = {}

M.core_parsers = {
  "bash",
  "bibtex",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "html",
  "http",
  "javascript",
  "json",
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local function attach_waiting(adapter, pending, language)
  local request = pending[language]
  pending[language] = nil
  if not request then
    return
  end

  for buffer in pairs(request.buffers) do
    if adapter.buffer_uses_language(buffer, language) then
      adapter.attach(buffer, language)
    end
  end
end

function M.new(adapter)
  local pending = {}

  local function install(languages, buffers)
    for _, language in ipairs(languages) do
      pending[language] = { buffers = buffers[language] or {} }
    end

    adapter.install(languages, function()
      for _, language in ipairs(languages) do
        attach_waiting(adapter, pending, language)
      end
    end)
  end

  local function bootstrap()
    local missing = {}
    for _, language in ipairs(M.core_parsers) do
      if not adapter.is_managed(language) and not pending[language] then
        table.insert(missing, language)
      end
    end
    if #missing > 0 then
      install(missing, {})
    end
  end

  local function open(buffer, filetype)
    local language = adapter.language_for_filetype(filetype)
    if not language or adapter.attach(buffer, language) then
      return
    end
    if not adapter.is_available(language) then
      return
    end

    if pending[language] then
      pending[language].buffers[buffer] = true
      return
    end

    install({ language }, { [language] = { [buffer] = true } })
  end

  return {
    bootstrap = bootstrap,
    open = open,
  }
end

return M
```

- [ ] **Step 4: Run policy tests and verify success**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_policy_spec.lua
```

Expected: exit 0 and `treesitter policy tests passed`.

- [ ] **Step 5: Commit parser policy**

```bash
git add lua/config/treesitter_policy.lua
git commit -m "feat(nvim): add treesitter parser policy"
```

### Task 2: nvim-treesitter Adapter and Plugin Spec

**Files:**
- Create: `lua/config/treesitter.lua`
- Modify: `lua/plugins/treesitter.lua`
- Create: `tests/treesitter_plugin_spec.lua`
- Modify: `lazy-lock.json`

**Interfaces:**
- Consumes: `config.treesitter_policy.new(adapter)` and `.core_parsers` from Task 1.
- Produces: `require("config.treesitter").setup(): nil`.
- Consumes upstream APIs: `get_available()`, `get_installed("parsers")`, `install(languages):await(callback)`, `vim.treesitter.language.get_lang()`, `vim.treesitter.language.add()`, and `vim.treesitter.start()`.

- [ ] **Step 1: Write failing plugin-spec test**

Create `tests/treesitter_plugin_spec.lua`:

```lua
local spec = assert(loadfile("lua/plugins/treesitter.lua"))()

assert(spec[1] == "nvim-treesitter/nvim-treesitter", "wrong Treesitter plugin")
assert(spec.branch == "main", "main branch must be explicit")
assert(spec.lazy == false, "nvim-treesitter must load eagerly")
assert(spec.build == ":TSUpdate", "parser updates must follow plugin updates")
assert(type(spec.config) == "function", "Treesitter adapter setup is missing")

print("treesitter plugin spec tests passed")
```

- [ ] **Step 2: Run plugin-spec test and verify failure**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_plugin_spec.lua
```

Expected: nonzero exit with `wrong Treesitter plugin`.

- [ ] **Step 3: Add production Neovim adapter**

Create `lua/config/treesitter.lua`:

```lua
local M = {}

local function to_set(values)
  local result = {}
  for _, value in ipairs(values) do
    result[value] = true
  end
  return result
end

function M.setup()
  local treesitter = require("nvim-treesitter")
  local Policy = require("config.treesitter_policy")
  local available = to_set(treesitter.get_available())
  local managed = to_set(treesitter.get_installed("parsers"))

  local adapter = {
    is_managed = function(language)
      return managed[language] == true
    end,
    is_available = function(language)
      return available[language] == true
    end,
    language_for_filetype = vim.treesitter.language.get_lang,
    install = function(languages, on_complete)
      treesitter.install(languages):await(on_complete)
    end,
    attach = function(buffer, language)
      if not vim.treesitter.language.add(language) then
        return false
      end
      vim.treesitter.start(buffer, language)
      return true
    end,
    buffer_uses_language = function(buffer, language)
      if not vim.api.nvim_buf_is_valid(buffer) then
        return false
      end
      return vim.treesitter.language.get_lang(vim.bo[buffer].filetype) == language
    end,
  }

  local policy = Policy.new(adapter)
  local group = vim.api.nvim_create_augroup("TreesitterParserPolicy", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      policy.open(args.buf, args.match)
    end,
  })
  policy.bootstrap()
end

return M
```

- [ ] **Step 4: Replace manager plugin spec**

Replace `lua/plugins/treesitter.lua` with:

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("config.treesitter").setup()
  end,
}
```

- [ ] **Step 5: Run local tests**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_policy_spec.lua
nvim --headless -u NONE -l tests/treesitter_plugin_spec.lua
git diff --check
```

Expected: both test commands exit 0 with their pass messages; `git diff --check` prints nothing.

- [ ] **Step 6: Install plugin and refresh lockfile**

Run:

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: lazy.nvim removes `tree-sitter-manager.nvim`, installs `nvim-treesitter`, runs `:TSUpdate`, and exits 0. `lazy-lock.json` contains `nvim-treesitter` on `main` and no `tree-sitter-manager.nvim` entry.

- [ ] **Step 7: Re-run plugin and startup checks**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_policy_spec.lua
nvim --headless -u NONE -l tests/treesitter_plugin_spec.lua
nvim --headless "+lua assert(vim.fn.exists(':TSInstall') == 2)" "+lua assert(vim.fn.exists(':TSUninstall') == 2)" "+lua assert(vim.fn.exists(':TSUpdate') == 2)" "+lua assert(vim.fn.exists(':TSManager') == 0)" +qa
```

Expected: all commands exit 0.

- [ ] **Step 8: Commit plugin migration**

```bash
git add lua/config/treesitter.lua lua/plugins/treesitter.lua lazy-lock.json
git commit -m "feat(nvim): restore nvim-treesitter"
```

### Task 3: Documentation and End-to-End Verification

**Files:**
- Modify: `README.md`
- Create: `tests/treesitter_e2e.lua`

**Interfaces:**
- Documents commands produced by Task 2: `:TSInstall`, `:TSUninstall`, and `:TSUpdate`.
- Documents parser behavior produced by Tasks 1 and 2: proactive core installation, automatic supported-language installation, and highlighting.

- [ ] **Step 1: Prove documentation is stale**

Run:

```bash
rg -n "tree-sitter-manager.nvim|:TSManager" README.md
```

Expected: matches in overview, first-run instructions, and Treesitter section.

- [ ] **Step 2: Update README**

Make these exact content changes:

- Replace every user-facing `tree-sitter-manager.nvim` name with `nvim-treesitter` and link to `https://github.com/nvim-treesitter/nvim-treesitter`.
- In First Run, require Neovim 0.12+, Tree-sitter CLI 0.26.1+ installed outside npm, `curl`, `tar`, and a C compiler.
- State that configured core parsers install proactively and other supported parsers install when their filetype opens.
- Remove `:TSManager` from the command list.
- Keep `:TSInstall <lang>`, `:TSUninstall <lang>`, and `:TSUpdate`.
- State that lazy.nvim runs `:TSUpdate` after nvim-treesitter updates.
- State that highlighting and injections are enabled while Tree-sitter folds and experimental indentation remain off.

- [ ] **Step 3: Verify docs and full repository references**

Run:

```bash
if rg -n "tree-sitter-manager.nvim|:TSManager" README.md lua lazy-lock.json; then exit 1; fi
rg -n "nvim-treesitter|:TSInstall|:TSUninstall|:TSUpdate|0\.26\.1|curl|tar" README.md
git diff --check
```

Expected: first command exits 0 without matches; second command finds all required documentation; `git diff --check` prints nothing.

- [ ] **Step 4: Add isolated real-parser end-to-end test**

Create `tests/treesitter_e2e.lua`:

```lua
local plugin_dir = assert(vim.env.NVIM_TS_PLUGIN_DIR, "NVIM_TS_PLUGIN_DIR is required")
local install_dir = assert(vim.env.NVIM_TS_INSTALL_DIR, "NVIM_TS_INSTALL_DIR is required")

vim.opt.runtimepath:prepend(vim.fn.getcwd())
vim.opt.runtimepath:prepend(plugin_dir)
vim.cmd.runtime("plugin/nvim-treesitter.lua")

require("nvim-treesitter").setup({ install_dir = install_dir })
require("config.treesitter").setup()

vim.cmd.enew()
vim.cmd("setfiletype toml")

local buffer = vim.api.nvim_get_current_buf()
local attached = vim.wait(300000, function()
  return vim.treesitter.highlighter.active[buffer] ~= nil
end, 100)

assert(attached, "toml parser did not install and attach within five minutes")
assert(vim.treesitter.language.add("toml"), "toml parser is not loadable")
print("treesitter end-to-end test passed")
```

- [ ] **Step 5: Run end-to-end checks**

Run:

```bash
nvim --headless -u NONE -l tests/treesitter_policy_spec.lua
nvim --headless -u NONE -l tests/treesitter_plugin_spec.lua
nvim --headless "+enew" "+setfiletype lua" "+lua vim.wait(300000, function() return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil end, 100)" "+lua assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)" +qa
treesitter_plugin_dir="$(nvim --headless -u NONE "+lua io.write(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter')" +qa 2>/dev/null)"
treesitter_test_root="$(mktemp -d)"
NVIM_TS_PLUGIN_DIR="$treesitter_plugin_dir" NVIM_TS_INSTALL_DIR="$treesitter_test_root/site" nvim --headless -u NONE -l tests/treesitter_e2e.lua
nvim --headless "+checkhealth nvim-treesitter" +qa
```

Expected: unit tests pass; Lua buffer gains an active Tree-sitter highlighter; isolated TOML open installs one supported non-core parser and prints `treesitter end-to-end test passed`; health output contains no errors caused by this configuration.

- [ ] **Step 6: Delete temporary test files**

Delete these exact files with `apply_patch` after every test has passed:

- `tests/treesitter_policy_spec.lua`
- `tests/treesitter_plugin_spec.lua`
- `tests/treesitter_e2e.lua`

Run:

```bash
if test -e tests/treesitter_policy_spec.lua || test -e tests/treesitter_plugin_spec.lua || test -e tests/treesitter_e2e.lua; then exit 1; fi
```

Expected: exit 0. No test files remain in final repository state.

- [ ] **Step 7: Inspect final scope**

Run:

```bash
git status --short
git diff --stat HEAD
git diff -- lua/config/treesitter.lua lua/config/treesitter_policy.lua lua/plugins/treesitter.lua README.md lazy-lock.json
```

Expected: only config, README, and lockfile changes are part of this migration. No `tests/` files remain. Pre-existing changes in `lua/config/options.lua`, Ghostty config, and Zsh config remain unstaged and unchanged by this work.

- [ ] **Step 8: Commit documentation**

```bash
git add README.md
git commit -m "docs(nvim): document nvim-treesitter"
```

## Final Verification

- [ ] Run final startup checks without recreating test files:

```bash
nvim --headless "+lua assert(vim.fn.exists(':TSInstall') == 2)" "+lua assert(vim.fn.exists(':TSUninstall') == 2)" "+lua assert(vim.fn.exists(':TSUpdate') == 2)" "+lua assert(vim.fn.exists(':TSManager') == 0)" +qa
nvim --headless "+enew" "+setfiletype lua" "+lua vim.wait(300000, function() return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil end, 100)" "+lua assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)" +qa
if test -e tests/treesitter_policy_spec.lua || test -e tests/treesitter_plugin_spec.lua || test -e tests/treesitter_e2e.lua; then exit 1; fi
git diff --check HEAD~3
```

Expected: every command exits 0, no test files or whitespace errors remain, and no manager references remain in runtime files or README.
