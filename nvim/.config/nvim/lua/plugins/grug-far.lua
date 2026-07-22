return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    {
      "<leader>fr",
      function()
        require("grug-far").open()
      end,
      desc = "Find and replace",
    },
    {
      "<leader>fR",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Find and replace in file",
    },
  },
  opts = {},
}
