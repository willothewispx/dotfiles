local M = {}

local capture = require("herdr_send.capture")
local format = require("herdr_send.format")
local targets = require("herdr_send.targets")
local transport = require("herdr_send.transport")

local config = {
  submit = false,
  focus_after_send = false,
  max_payload_bytes = 64 * 1024,
  normal_mode = "buffer",
  multiline_strategy = "auto",
  bracketed_paste_agents = {
    codex = true,
    claude = true,
    grok = true,
  },
  herdr_bin = nil,
  context_file_dir = nil,
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "herdr-send" })
end

local function merge(dst, src)
  if type(src) ~= "table" then
    return dst
  end
  for key, value in pairs(src) do
    if type(value) == "table" and type(dst[key]) == "table" and not vim.islist(value) then
      merge(dst[key], value)
    else
      dst[key] = value
    end
  end
  return dst
end

function M.setup(opts)
  merge(config, opts or {})
  return config
end

function M.config()
  return config
end

local function stage(kind, opts)
  opts = opts or {}
  opts.normal_mode = opts.normal_mode or config.normal_mode

  local ctx, capture_err = capture.capture(opts)
  if not ctx then
    notify(capture_err, vim.log.levels.ERROR)
    return
  end

  local payload, err
  if kind == "reference" then
    payload, err = format.reference(ctx)
  elseif kind == "content" then
    payload = format.content(ctx)
  elseif kind == "diagnostics" then
    payload = format.diagnostics(ctx, capture.diagnostics_in_range(ctx))
  else
    notify("Unknown kind: " .. tostring(kind), vim.log.levels.ERROR)
    return
  end

  if not payload then
    notify(err or "Empty payload", vim.log.levels.ERROR)
    return
  end

  payload, err = format.validate(payload, config.max_payload_bytes)
  if not payload then
    notify(err, vim.log.levels.ERROR)
    return
  end

  targets.resolve(config, {}, function(target, target_err)
    if not target then
      if target_err ~= "Target selection cancelled" then
        notify(target_err, vim.log.levels.ERROR)
      end
      return
    end

    transport.stage(config, target, payload, function(ok, transport_err, result)
      if not ok then
        notify(transport_err, vim.log.levels.ERROR)
        return
      end
      local suffix = result and result.mode == "context_file" and " (via context file)" or ""
      notify(("Staged for %s (%s)%s"):format(target.agent or "agent", target.pane_id, suffix))
    end)
  end)
end

function M.reference(opts)
  stage("reference", opts)
end

function M.send(opts)
  stage("content", opts)
end

function M.diagnostics(opts)
  stage("diagnostics", opts)
end

function M.select_target()
  targets.resolve(config, { force = true }, function(target, err)
    if not target then
      if err ~= "Target selection cancelled" then
        notify(err, vim.log.levels.ERROR)
      end
      return
    end
    notify(("Target: %s (%s)"):format(target.agent or "agent", target.pane_id))
  end)
end

return M
