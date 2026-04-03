return {
  "akinsho/toggleterm.nvim",
  version = "*",
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
