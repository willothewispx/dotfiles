local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local state = {
  prev_win = nil,
}

local function on_open(term)
  vim.cmd("startinsert!")
  local opts = { buffer = term.bufnr, silent = true }
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", function()
    M.focus_code()
  end, opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

local function new_terminal(count)
  return Terminal:new({
    hidden = true,
    count = count,
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "curved",
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.85)
      end,
    },
    on_open = on_open,
  })
end

local shell = new_terminal(1)
local shell2 = new_terminal(2)

function M.toggle()
  state.prev_win = vim.api.nvim_get_current_win()
  shell:toggle()
end

local function focus(term)
  if term:is_open() and term.window and vim.api.nvim_win_is_valid(term.window) then
    if vim.api.nvim_get_current_win() ~= term.window then
      state.prev_win = vim.api.nvim_get_current_win()
    end
    vim.api.nvim_set_current_win(term.window)
    vim.cmd("startinsert!")
    return
  end

  state.prev_win = vim.api.nvim_get_current_win()
  term:toggle()
end

function M.focus()
  focus(shell)
end

function M.toggle_second()
  state.prev_win = vim.api.nvim_get_current_win()
  shell2:toggle()
end

function M.focus_second()
  focus(shell2)
end

function M.focus_code()
  vim.cmd("stopinsert")
  if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
    vim.api.nvim_set_current_win(state.prev_win)
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local is_shell = shell.window and win == shell.window
    local is_shell2 = shell2.window and win == shell2.window
    if not is_shell and not is_shell2 then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "" then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
end

return M
