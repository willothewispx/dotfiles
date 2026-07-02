return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    options = {
      theme = "catppuccin-mocha",
      globalstatus = true,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          path = 1,
        },
      },
      lualine_x = {
        function()
          local ft = vim.bo.filetype
          if ft ~= "http" and ft ~= "rest" and ft ~= "kulala_ui" then
            return ""
          end

          local ok, kulala = pcall(require, "kulala")
          if not ok then
            return ""
          end

          return "Kulala " .. kulala.get_selected_env()
        end,
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = {
      "nvim-tree",
      "quickfix",
      "lazy",
    },
  },
}
