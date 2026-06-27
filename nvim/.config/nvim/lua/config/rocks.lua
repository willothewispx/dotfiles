local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")
local luajit_prefix = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks-luajit")
local lua_bindir = vim.fs.joinpath(luajit_prefix, "bin")

local function first_existing_path(paths)
  for _, path in ipairs(paths) do
    if vim.uv.fs_stat(path) then
      return path
    end
  end
end

local function configure_luajit_bootstrap()
  if vim.env.LUA_BINDIR_SET == "yes" then
    return
  end

  local luajit = vim.fn.exepath("luajit")
  if luajit == "" then
    return
  end

  local ok, err = pcall(vim.fn.mkdir, lua_bindir, "p")
  if not ok then
    vim.notify("Failed to create LuaJIT bootstrap directory for rocks.nvim: " .. tostring(err), vim.log.levels.WARN)
    return
  end

  local lua = vim.fs.joinpath(lua_bindir, "lua")

  if not vim.uv.fs_stat(lua) then
    local ok = vim.uv.fs_symlink(luajit, lua)
    if not ok and vim.fn.executable(lua) == 0 then
      vim.notify("Failed to create LuaJIT bootstrap shim for rocks.nvim: " .. lua, vim.log.levels.WARN)
      return
    end
  end

  if vim.fn.executable(lua) == 0 then
    vim.notify("LuaJIT bootstrap shim for rocks.nvim is not executable: " .. lua, vim.log.levels.WARN)
    return
  end

  local luajit_include = first_existing_path({
    "/opt/homebrew/opt/luajit/include/luajit-2.1",
    "/opt/homebrew/include/luajit-2.1",
    "/usr/local/opt/luajit/include/luajit-2.1",
    "/usr/local/include/luajit-2.1",
  })

  if luajit_include then
    local include_parent = vim.fs.joinpath(luajit_prefix, "include")
    local include_target = vim.fs.joinpath(include_parent, "luajit-2.1")

    local include_ok, include_err = pcall(vim.fn.mkdir, include_parent, "p")
    if not include_ok then
      vim.notify("Failed to create LuaJIT include directory for rocks.nvim: " .. tostring(include_err), vim.log.levels.WARN)
      return
    end

    if not vim.uv.fs_stat(include_target) then
      local ok = vim.uv.fs_symlink(luajit_include, include_target)
      if not ok and not vim.uv.fs_stat(vim.fs.joinpath(include_target, "lua.h")) then
        vim.notify("Failed to create LuaJIT include shim for rocks.nvim: " .. include_target, vim.log.levels.WARN)
        return
      end
    end

    if not vim.uv.fs_stat(vim.fs.joinpath(include_target, "lua.h")) then
      vim.notify("LuaJIT include shim for rocks.nvim is missing lua.h: " .. include_target, vim.log.levels.WARN)
      return
    end
  end

  vim.env.LUA_BINDIR = lua_bindir
  vim.env.LUA_BINDIR_SET = "yes"
  vim.env.PATH = lua_bindir .. ":" .. vim.env.PATH
end

configure_luajit_bootstrap()

local parser_names = {
  "bash",
  "bibtex",
  "css",
  "diff",
  "dockerfile",
  "go",
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
  "regex",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local rocks_config = {
  auto_sync = "disable",
  config_path = vim.fs.joinpath(vim.fn.stdpath("config"), "rocks.toml"),
  rocks_path = vim.fs.normalize(install_location),
  treesitter = {
    auto_highlight = parser_names,
    auto_install = "prompt",
    parser_map = {
      bib = "bibtex",
      ecma = "javascript",
      ecmascript = "javascript",
      gitdiff = "diff",
      gyp = "python",
      javascriptreact = "javascript",
      js = "javascript",
      jsonc = "json",
      jsx = "javascript",
      pandoc = "markdown",
      plaintex = "latex",
      py = "python",
      sh = "bash",
      tex = "latex",
      ts = "typescript",
      ["typescript.tsx"] = "tsx",
      typescriptreact = "tsx",
    },
  },
}

vim.g.rocks_nvim = rocks_config

local luarocks_path = {
  vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
  vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
  vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
  vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

local function add_rocks_runtimepath()
  local paths = vim.opt.runtimepath:get()

  for _, rock in ipairs({ "rocks.nvim", "rocks-treesitter.nvim", "tree-sitter-*" }) do
    local pattern = vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", rock, "*")
    for _, path in ipairs(vim.fn.glob(pattern, false, true)) do
      if not vim.list_contains(paths, path) then
        vim.opt.runtimepath:append(path)
      end
    end
  end
end

add_rocks_runtimepath()

if not pcall(require, "rocks") then
  local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")

  if not vim.uv.fs_stat(rocks_location) then
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/lumen-oss/rocks.nvim",
      rocks_location,
    })
    assert(vim.v.shell_error == 0, "rocks.nvim installation failed:\n" .. output)
  end

  vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))
  vim.fn.delete(rocks_location, "rf")
  add_rocks_runtimepath()
end

vim.cmd.runtime("plugin/rocks.lua")
vim.cmd.runtime("plugin/rocks-treesitter.lua")

return {
  refresh_runtimepath = add_rocks_runtimepath,
}
