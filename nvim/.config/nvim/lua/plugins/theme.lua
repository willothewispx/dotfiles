return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    custom_highlights = function(palette)
      return {
        FlashLabel = {
          fg = palette.base,
          bg = palette.red,
          bold = true,
        },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-mocha")

    local function set_nvim_tree_git_highlights()
      local palette = require("catppuccin.palettes").get_palette("mocha")
      local highlights = {
        NvimTreeGitFileDirtyHL = { fg = palette.peach, bold = true },
        NvimTreeGitFolderDirtyHL = { fg = palette.peach, bold = true },
        NvimTreeGitFileNewHL = { fg = palette.green, bold = true },
        NvimTreeGitFolderNewHL = { fg = palette.green, bold = true },
        NvimTreeGitFileRenamedHL = { fg = palette.blue, bold = true },
        NvimTreeGitFolderRenamedHL = { fg = palette.blue, bold = true },
        NvimTreeGitFileStagedHL = { fg = palette.teal, bold = true },
        NvimTreeGitFolderStagedHL = { fg = palette.teal, bold = true },
      }

      for group, value in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, value)
      end
    end

    set_nvim_tree_git_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_nvim_tree_git_highlights,
    })
  end,
}
