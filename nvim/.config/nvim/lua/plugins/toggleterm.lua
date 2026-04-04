return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local state = {
      prev_win = nil,
    }
    local shell
    local shell2

    local function focus_code(term1, term2)
      vim.cmd("stopinsert")
      if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
        vim.api.nvim_set_current_win(state.prev_win)
        return
      end

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local is_term1 = term1.window and win == term1.window
        local is_term2 = term2.window and win == term2.window
        if not is_term1 and not is_term2 then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end
    end

    local function on_open(term)
      vim.cmd("startinsert!")
      local opts = { buffer = term.bufnr, silent = true }
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", function()
        focus_code(shell, shell2)
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

    shell = new_terminal(1)
    shell2 = new_terminal(2)

    local function toggle(term)
      state.prev_win = vim.api.nvim_get_current_win()
      term:toggle()
    end

    vim.keymap.set("n", "<leader>tt", function()
      toggle(shell)
    end, { desc = "Floating terminal" })
    vim.keymap.set("n", "<leader>tT", function()
      toggle(shell2)
    end, { desc = "Second floating terminal" })
    vim.keymap.set("n", "<leader>tb", function()
      focus_code(shell, shell2)
    end, { desc = "Focus code from terminal" })
  end,
  opts = {
    direction = "vertical",
    size = function(term)
      if term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.42)
      end
      return 20
    end,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_mode = true,
    persist_size = true,
    close_on_exit = false,
    shade_terminals = true,
    shading_factor = 1,
    highlights = {
      Normal = {
        guibg = "#15161e",
      },
      NormalFloat = {
        guibg = "#15161e",
      },
      FloatBorder = {
        guifg = "#3b4261",
        guibg = "#15161e",
      },
    },
  },
}
