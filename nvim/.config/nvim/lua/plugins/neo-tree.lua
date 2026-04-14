local function node_search_dir(state)
  local node = state.tree and state.tree:get_node()
  if not node then
    return nil
  end

  local path = node.path or node:get_id()
  if node.type == "directory" then
    return path
  end

  return vim.fs.dirname(path)
end

local function search_in_node_dir(state, picker)
  local dir = node_search_dir(state)
  if not dir or dir == "" then
    vim.notify("No folder selected in Neo-tree", vim.log.levels.WARN)
    return
  end

  Snacks.picker[picker]({
    cwd = dir,
  })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          reveal = true,
          source = "filesystem",
          position = "left",
        })
      end,
      desc = "Toggle file tree",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          reveal = true,
          source = "filesystem",
          position = "left",
          focus = true,
        })
      end,
      desc = "Focus file tree",
    },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = {
      "terminal",
      "Trouble",
      "qf",
      "edgy",
      "nofile",
      "text.kulala_ui",
      "json.kulala_ui",
      "http.kulala_ui",
    },
    filesystem = {
      commands = {
        search_files = function(state)
          search_in_node_dir(state, "files")
        end,
        search_grep = function(state)
          search_in_node_dir(state, "grep")
        end,
      },
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["F"] = "search_files",
          ["G"] = "search_grep",
        },
      },
    },
    window = {
      position = "left",
      width = 36,
    },
  },
}
