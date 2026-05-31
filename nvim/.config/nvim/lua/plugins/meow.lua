return {
  "retran/meow.yarn.nvim",
  cmd = "MeowYarn",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>lt",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "supertypes")
      end,
      desc = "Type hierarchy (supertypes)",
    },
    {
      "<leader>lT",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "subtypes")
      end,
      desc = "Type hierarchy (subtypes)",
    },
    {
      "<leader>lc",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end,
      desc = "Call hierarchy (callers)",
    },
    {
      "<leader>lC",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end,
      desc = "Call hierarchy (callees)",
    },
  },
  opts = {
    window = {
      border = "rounded",
    },
  },
}
