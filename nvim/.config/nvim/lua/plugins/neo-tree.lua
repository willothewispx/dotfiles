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

local tree_width = 36

local function reset_tree_width(state)
  if state.window.position == "float" or not state.winid then
    return
  end

  state.window.auto_expand_width = false
  state.window.last_user_width = tree_width
  state.window.width = tree_width
  state.win_width = tree_width
  vim.api.nvim_win_set_width(state.winid, tree_width)
end

local function open_and_reset_width(state)
  local node = state.tree and state.tree:get_node()
  require("neo-tree.sources.filesystem.commands").open(state)

  if node and node.type == "file" then
    vim.schedule(function()
      reset_tree_width(state)
    end)
  end
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
        open_and_reset_width = open_and_reset_width,
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
          ["<cr>"] = "open_and_reset_width",
          ["H"] = "toggle_hidden",
          ["F"] = "search_files",
          ["G"] = "search_grep",
        },
      },
    },
    window = {
      position = "left",
      width = tree_width,
    },
  },
}
