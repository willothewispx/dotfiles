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
