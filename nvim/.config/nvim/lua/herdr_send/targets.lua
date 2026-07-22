local M = {}

local cli = require("herdr_send.cli")

local remembered_pane_id = nil

local function agent_cwd(agent)
  return agent.foreground_cwd or agent.cwd or ""
end

local function label(agent)
  local status = agent.agent_status or "unknown"
  local name = agent.agent or "agent"
  local cwd = agent_cwd(agent)
  local short = cwd ~= "" and vim.fn.fnamemodify(cwd, ":~:.") or "?"
  return ("%s [%s]  %s  (%s)"):format(name, status, short, agent.pane_id)
end

local function rank(agent, env)
  local score = 100
  if env.workspace_id and agent.workspace_id == env.workspace_id then
    score = score - 40
  end
  if env.tab_id and agent.tab_id == env.tab_id then
    score = score - 20
  end
  if env.cwd and agent_cwd(agent) ~= "" then
    local agent_norm = vim.fs.normalize(agent_cwd(agent))
    if agent_norm == env.cwd or agent_norm:find(env.cwd, 1, true) == 1 or env.cwd:find(agent_norm, 1, true) == 1 then
      score = score - 10
    end
  end
  return score
end

local function env_context()
  local cwd = (vim.uv or vim.loop).cwd() or vim.fn.getcwd()
  return {
    workspace_id = vim.env.HERDR_WORKSPACE_ID,
    tab_id = vim.env.HERDR_TAB_ID,
    pane_id = vim.env.HERDR_PANE_ID,
    cwd = vim.fs.normalize(cwd),
  }
end

function M.list(config, callback)
  local env = env_context()

  local function finish(agents, err)
    if not agents then
      callback(nil, err)
      return
    end

    local candidates = {}
    for _, agent in ipairs(agents) do
      if agent.pane_id and agent.pane_id ~= env.pane_id then
        candidates[#candidates + 1] = agent
      end
    end

    table.sort(candidates, function(a, b)
      local ra, rb = rank(a, env), rank(b, env)
      if ra ~= rb then
        return ra < rb
      end
      local na, nb = a.agent or "", b.agent or ""
      if na ~= nb then
        return na < nb
      end
      return (a.pane_id or "") < (b.pane_id or "")
    end)

    callback(candidates)
  end

  return cli.agent_list(config, finish)
end

function M.remember(pane_id)
  remembered_pane_id = pane_id
end

function M.remembered()
  return remembered_pane_id
end

local function find_by_pane(candidates, pane_id)
  if not pane_id then
    return nil
  end
  for _, agent in ipairs(candidates) do
    if agent.pane_id == pane_id then
      return agent
    end
  end
end

function M.resolve(config, opts, callback)
  opts = opts or {}
  M.list(config, function(candidates, err)
    if not candidates then
      callback(nil, err)
      return
    end
    if #candidates == 0 then
      callback(nil, "No Herdr agents found (is the server running?)")
      return
    end

    if not opts.force then
      local remembered = find_by_pane(candidates, remembered_pane_id)
      if remembered then
        callback(remembered)
        return
      end
      if #candidates == 1 then
        M.remember(candidates[1].pane_id)
        callback(candidates[1])
        return
      end
    end

    local items = {}
    for _, agent in ipairs(candidates) do
      items[#items + 1] = label(agent)
    end

    vim.ui.select(items, { prompt = "Herdr agent target" }, function(choice, idx)
      if not choice or not idx then
        callback(nil, "Target selection cancelled")
        return
      end
      local selected = candidates[idx]
      M.remember(selected.pane_id)
      callback(selected)
    end)
  end)
end

return M
