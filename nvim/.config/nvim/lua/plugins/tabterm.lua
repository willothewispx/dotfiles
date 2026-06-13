return {
  "kremovtort/tabterm.nvim",
  version = "*",
  opts = {
    ui = {
      border = "round",
      sidebar_width = 30,
      float = {
        width = 0.9,
        height = 0.85,
      },
    },
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("tabterm").toggle()
      end,
      desc = "Toggle terminal workspace",
    },
    {
      "<leader>tT",
      function()
        require("tabterm").new_shell()
      end,
      desc = "New terminal shell",
    },
    {
      "<leader>tc",
      function()
        require("tabterm").new_command()
      end,
      desc = "New command terminal",
    },
  },
}
