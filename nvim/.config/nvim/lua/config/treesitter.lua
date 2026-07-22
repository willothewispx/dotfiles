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
