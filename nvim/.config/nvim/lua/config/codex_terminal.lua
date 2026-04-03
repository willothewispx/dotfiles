local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local state = {
  prev_win = nil,
}

local function project_root()
  local cwd = vim.fn.getcwd()
  local git_root = vim.fs.root(cwd, ".git")
  return git_root or cwd
end

local codex = Terminal:new({
  cmd = "codex",
  hidden = true,
  count = 99,
  direction = "vertical",
  close_on_exit = false,
  dir = project_root(),
  on_open = function(term)
    vim.cmd("startinsert!")
    local opts = { buffer = term.bufnr, silent = true }
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", function()
      M.focus_code()
    end, opts)
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
  end,
})

function M.toggle()
  state.prev_win = vim.api.nvim_get_current_win()
  codex.dir = project_root()
  codex:toggle(80, "vertical")
end

function M.focus()
  if codex:is_open() and codex.window and vim.api.nvim_win_is_valid(codex.window) then
    if vim.api.nvim_get_current_win() ~= codex.window then
      state.prev_win = vim.api.nvim_get_current_win()
    end
    vim.api.nvim_set_current_win(codex.window)
    vim.cmd("startinsert!")
    return
  end

  M.toggle()
end

function M.focus_code()
  vim.cmd("stopinsert")
  if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
    vim.api.nvim_set_current_win(state.prev_win)
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not (codex.window and win == codex.window) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
end

function M.run_here()
  local file = vim.api.nvim_buf_get_name(0)
  M.focus()
  if file ~= "" and codex.job_id then
    vim.fn.chansend(codex.job_id, "Please inspect " .. file .. "\n")
  end
end

return M
