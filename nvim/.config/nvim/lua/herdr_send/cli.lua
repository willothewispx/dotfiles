local M = {}

local function binary(config)
  return config.herdr_bin or vim.env.HERDR_BIN_PATH or "herdr"
end

local function result_error(result)
  local detail = result.stderr ~= "" and result.stderr or result.stdout
  detail = (detail or ""):gsub("%s+$", "")
  if detail == "" then
    detail = "Herdr exited with status " .. tostring(result.code)
  end
  return detail
end

function M.run(config, args, callback)
  local argv = { binary(config) }
  vim.list_extend(argv, args)

  if callback then
    local ok, process = pcall(vim.system, argv, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          callback(nil, result_error(result), result)
          return
        end
        callback(result.stdout or "", nil, result)
      end)
    end)
    if not ok then
      vim.schedule(function()
        callback(nil, "Could not start Herdr: " .. tostring(process))
      end)
      return nil
    end
    return process
  end

  local ok, process = pcall(vim.system, argv, { text = true })
  if not ok then
    return nil, "Could not start Herdr: " .. tostring(process)
  end
  local waited, result = pcall(process.wait, process, 5000)
  if not waited then
    return nil, "Could not wait for Herdr: " .. tostring(result)
  end
  if result.code ~= 0 then
    return nil, result_error(result), result
  end
  return result.stdout or "", nil, result
end

local function decode_json(output)
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" then
    return nil, "Herdr returned invalid JSON"
  end
  if decoded.error then
    local message = type(decoded.error) == "table" and decoded.error.message or decoded.error
    return nil, "Herdr API error: " .. tostring(message)
  end
  return decoded
end

function M.agent_list(config, callback)
  local function unwrap(output, err)
    if not output then
      return nil, err
    end
    local decoded, decode_err = decode_json(output)
    if not decoded then
      return nil, decode_err
    end
    local agents = decoded.result and decoded.result.agents
    if type(agents) ~= "table" then
      return nil, "Herdr agent list missing result.agents"
    end
    return agents
  end

  if callback then
    return M.run(config, { "agent", "list" }, function(output, err)
      callback(unwrap(output, err))
    end)
  end
  return unwrap(M.run(config, { "agent", "list" }))
end

function M.agent_send(config, pane_id, text, callback)
  return M.run(config, { "agent", "send", pane_id, text }, callback)
end

function M.agent_focus(config, pane_id, callback)
  return M.run(config, { "agent", "focus", pane_id }, callback)
end

function M.pane_enter(config, pane_id, callback)
  return M.run(config, { "pane", "send-keys", pane_id, "enter" }, callback)
end

function M.executable(config)
  local bin = binary(config)
  if bin:find("/", 1, true) then
    return vim.fn.executable(bin) == 1, bin
  end
  local found = vim.fn.exepath(bin)
  return found ~= "", found ~= "" and found or bin
end

return M
