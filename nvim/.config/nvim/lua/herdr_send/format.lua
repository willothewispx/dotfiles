local M = {}

local severity_names = {
  [vim.diagnostic.severity.ERROR] = "ERROR",
  [vim.diagnostic.severity.WARN] = "WARN",
  [vim.diagnostic.severity.INFO] = "INFO",
  [vim.diagnostic.severity.HINT] = "HINT",
}

local function line_suffix(ctx)
  if ctx.start_line == ctx.end_line then
    return "#L" .. ctx.start_line
  end
  return ("#L%d-L%d"):format(ctx.start_line, ctx.end_line)
end

function M.validate(payload, max_bytes)
  if type(payload) ~= "string" then
    return nil, "Payload must be a string"
  end
  if #payload > max_bytes then
    return nil, ("Payload is %d bytes; max is %d"):format(#payload, max_bytes)
  end
  return payload
end

local function path_reference(ctx)
  if ctx.unnamed or not ctx.relative_path then
    return nil
  end
  return "@" .. ctx.relative_path .. line_suffix(ctx)
end

function M.reference(ctx)
  local reference = path_reference(ctx)
  if not reference then
    return nil, "Reference needs a named buffer with a stable path"
  end
  if ctx.modified then
    return nil, "Buffer has unsaved changes; use ref+code (<leader>aY) so agent sees buffer text"
  end
  return reference
end

local function source_label(ctx)
  local reference = path_reference(ctx)
  if not reference then
    return ("Unnamed buffer L%d-L%d"):format(ctx.start_line, ctx.end_line)
  end
  return reference
end

local function fence_for(text)
  local longest = 0
  for run in text:gmatch("`+") do
    longest = math.max(longest, #run)
  end
  return string.rep("`", math.max(3, longest + 1))
end

local function language_for(filetype)
  return (filetype or ""):match("^[%w_+.-]+") or ""
end

function M.content(ctx)
  local label = source_label(ctx)
  if ctx.modified then
    label = label .. " (unsaved changes)"
  end

  local fence = fence_for(ctx.text or "")
  return table.concat({
    label,
    "",
    fence .. language_for(ctx.filetype),
    ctx.text or "",
    fence,
  }, "\n")
end

local function diagnostic_identity(diagnostic)
  local source = diagnostic.source and tostring(diagnostic.source) or nil
  local code = diagnostic.code ~= nil and tostring(diagnostic.code) or nil
  if source and code then
    return (" [%s:%s]"):format(source, code)
  elseif source then
    return (" [%s]"):format(source)
  elseif code then
    return (" [%s]"):format(code)
  end
  return ""
end

local function clean_message(message)
  return tostring(message or ""):gsub("[%s\r\n]+", " "):match("^%s*(.-)%s*$")
end

function M.diagnostics(ctx, diagnostics)
  local label = source_label(ctx)
  if ctx.modified then
    label = label .. " (unsaved changes)"
  end

  local lines = { "Diagnostics for " .. label .. ":", "" }
  if not diagnostics or #diagnostics == 0 then
    lines[#lines + 1] = "- No diagnostics in this range."
  else
    for _, diagnostic in ipairs(diagnostics) do
      local severity = severity_names[diagnostic.severity] or "ERROR"
      local line = (diagnostic.lnum or 0) + 1
      lines[#lines + 1] = ("- %s%s L%d: %s"):format(
        severity,
        diagnostic_identity(diagnostic),
        line,
        clean_message(diagnostic.message)
      )
    end
  end
  return table.concat(lines, "\n")
end

return M
