local M = {}

local uv = vim.uv or vim.loop

local function normalize_path(path)
  if not path or path == "" then
    return path
  end
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

function M.find_git_root(path)
  if not path or path == "" then
    return nil
  end

  local current = normalize_path(path)
  local stat = uv.fs_stat(current)
  if not (stat and stat.type == "directory") then
    current = vim.fs.dirname(current)
  end

  while current and current ~= "" do
    if uv.fs_stat(current .. "/.git") then
      return current
    end
    local parent = vim.fs.dirname(current)
    if not parent or parent == current then
      break
    end
    current = parent
  end
end

local function relative_path(root, path)
  root = normalize_path(root):gsub("/+$", "")
  path = normalize_path(path)
  if path == root then
    return vim.fs.basename(path)
  end
  if path:sub(1, #root + 1) == root .. "/" then
    return path:sub(#root + 2)
  end
  return path
end

function M.resolve_path(path, cwd)
  if not path or path == "" then
    return nil, nil
  end
  path = normalize_path(path)
  cwd = normalize_path(cwd or uv.cwd() or vim.fn.getcwd())
  local root = M.find_git_root(path) or cwd
  return relative_path(root, path), root
end

local function normalize_position(first, last)
  if first[1] > last[1] or (first[1] == last[1] and first[2] > last[2]) then
    return last, first
  end
  return first, last
end

local function visual_type(mode)
  if type(mode) ~= "string" or mode == "" then
    return nil
  end
  if mode:find("\22", 1, true) then
    return "\22"
  end
  if mode:find("V", 1, true) then
    return "V"
  end
  if mode:find("v", 1, true) then
    return "v"
  end
  return nil
end

function M.snapshot_visual()
  local mode = vim.fn.mode(1)
  local vtype = visual_type(mode)
  if not vtype then
    return nil
  end
  local first = vim.fn.getpos("v")
  local last = vim.fn.getpos(".")
  return {
    mode = vtype,
    pos1 = { first[1], first[2], first[3], first[4] },
    pos2 = { last[1], last[2], last[3], last[4] },
    start = { first[2], math.max(first[3], 1) },
    finish = { last[2], math.max(last[3], 1) },
  }
end

local function selection_text(bufnr, selection)
  local first, last = normalize_position(selection.start, selection.finish)
  local mode = selection.mode

  if type(vim.fn.getregion) == "function" then
    local pos1 = selection.pos1 or { 0, selection.start[1], selection.start[2], 0 }
    local pos2 = selection.pos2 or { 0, selection.finish[1], selection.finish[2], 0 }
    local ok, lines = pcall(vim.fn.getregion, pos1, pos2, {
      type = mode,
      exclusive = vim.o.selection == "exclusive",
    })
    if ok and type(lines) == "table" then
      return table.concat(lines, "\n"), first[1], last[1]
    end
  end

  -- Fallback when getregion unavailable or failed.
  if mode == "V" or mode == "line" then
    local lines = vim.api.nvim_buf_get_lines(bufnr, first[1] - 1, last[1], false)
    return table.concat(lines, "\n"), first[1], last[1]
  end

  -- Inclusive visual col (1-based byte start of last char) → exclusive 0-based end col.
  local function exclusive_end_col(line_text, inclusive_byte_col)
    if inclusive_byte_col <= 0 or line_text == "" then
      return 0
    end
    local char_i = vim.fn.charidx(line_text, inclusive_byte_col - 1)
    if char_i < 0 then
      return #line_text
    end
    local next_byte = vim.fn.byteidx(line_text, char_i + 1)
    if next_byte < 0 then
      return #line_text
    end
    return next_byte
  end

  if mode == "\22" or mode == "block" then
    local parts = {}
    local start_col = math.min(first[2], last[2]) - 1
    local end_byte = math.max(first[2], last[2])
    for line = first[1], last[1] do
      local source = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
      local line_start = math.min(math.max(start_col, 0), #source)
      local end_col
      if vim.o.selection == "exclusive" then
        end_col = math.min(math.max(end_byte - 1, line_start), #source)
      else
        end_col = exclusive_end_col(source, end_byte)
      end
      local part = vim.api.nvim_buf_get_text(bufnr, line - 1, line_start, line - 1, end_col, {})
      parts[#parts + 1] = part[1] or ""
    end
    return table.concat(parts, "\n"), first[1], last[1]
  end

  local start_col = math.max(first[2] - 1, 0)
  local source = vim.api.nvim_buf_get_lines(bufnr, last[1] - 1, last[1], false)[1] or ""
  local end_col
  if vim.o.selection == "exclusive" then
    end_col = math.max(last[2] - 1, 0)
  else
    end_col = exclusive_end_col(source, last[2])
  end
  local lines = vim.api.nvim_buf_get_text(bufnr, first[1] - 1, start_col, last[1] - 1, end_col, {})
  return table.concat(lines, "\n"), first[1], last[1]
end

local function line_range_text(bufnr, start_line, end_line)
  start_line = math.max(1, start_line)
  end_line = math.max(1, end_line)
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  return table.concat(lines, "\n"), start_line, end_line
end

function M.capture(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return nil, "Buffer is no longer valid"
  end

  local text, start_line, end_line
  local selection = opts.selection
  if selection == nil and not opts.require_selection then
    selection = M.snapshot_visual()
  end

  if opts.require_selection and not selection then
    return nil, "No visual selection"
  end

  if selection then
    text, start_line, end_line = selection_text(bufnr, selection)
  elseif opts.line1 and opts.line2 then
    text, start_line, end_line = line_range_text(bufnr, opts.line1, opts.line2)
  elseif opts.normal_mode == "line" then
    local cursor_line = opts.line or vim.api.nvim_win_get_cursor(0)[1]
    text, start_line, end_line = line_range_text(bufnr, cursor_line, cursor_line)
  else
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    text, start_line, end_line = line_range_text(bufnr, 1, line_count)
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local relative, root = M.resolve_path(name, opts.cwd)

  return {
    bufnr = bufnr,
    path = name ~= "" and normalize_path(name) or nil,
    relative_path = relative,
    git_root = root,
    unnamed = name == "",
    modified = vim.bo[bufnr].modified,
    filetype = vim.bo[bufnr].filetype,
    text = text,
    start_line = start_line,
    end_line = end_line,
    selection_mode = selection and selection.mode or "buffer",
  }
end

function M.diagnostics_in_range(ctx)
  local items = {}
  for _, diagnostic in ipairs(vim.diagnostic.get(ctx.bufnr)) do
    local diag_start = (diagnostic.lnum or 0) + 1
    local diag_end = (diagnostic.end_lnum or diagnostic.lnum or 0) + 1
    if diag_end >= ctx.start_line and diag_start <= ctx.end_line then
      items[#items + 1] = diagnostic
    end
  end

  table.sort(items, function(a, b)
    local a_line, b_line = a.lnum or 0, b.lnum or 0
    if a_line ~= b_line then
      return a_line < b_line
    end
    local a_sev = a.severity or vim.diagnostic.severity.ERROR
    local b_sev = b.severity or vim.diagnostic.severity.ERROR
    if a_sev ~= b_sev then
      return a_sev < b_sev
    end
    return (a.message or "") < (b.message or "")
  end)

  return items
end

return M
