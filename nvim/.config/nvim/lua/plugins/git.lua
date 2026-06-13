local function setup_codediff(_, opts)
  require("codediff").setup(opts)

  local navigation = require("codediff.ui.view.navigation")
  local next_hunk = navigation.next_hunk
  local prev_hunk = navigation.prev_hunk

  navigation.next_hunk = function()
    return next_hunk() or navigation.next_file()
  end

  navigation.prev_hunk = function()
    return prev_hunk() or navigation.prev_file()
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      preview_config = {
        border = "rounded",
      },
    },
    keys = {
      {
        "<leader>gB",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame line",
      },
      {
        "<leader>gd",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Diff current file",
      },
      {
        "<leader>gh",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview hunk",
      },
      {
        "]h",
        function()
          require("gitsigns").next_hunk()
        end,
        desc = "Next hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").prev_hunk()
        end,
        desc = "Previous hunk",
      },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    config = setup_codediff,
    keys = {
      { "<leader>go", "<cmd>CodeDiff<cr>", desc = "Open code diff" },
      { "<leader>gH", "<cmd>CodeDiff history %<cr>", desc = "File history" },
      { "<leader>gD", "<cmd>CodeDiff history<cr>", desc = "Repo history" },
    },
    opts = {
      diff = {
        cycle_hunks_across_files = true,
        layout = "side-by-side",
      },
      keymaps = {
        view = {
          next_hunk = "<Tab>",
          prev_hunk = "<S-Tab>",
        },
      },
    },
  },
}
