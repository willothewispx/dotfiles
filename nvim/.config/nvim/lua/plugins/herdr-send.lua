local function with_visual(action)
  return function()
    local selection = require("herdr_send.capture").snapshot_visual()
    if not selection then
      vim.notify("No visual selection", vim.log.levels.ERROR, { title = "herdr-send" })
      return
    end
    action({ selection = selection, require_selection = true })
  end
end

return {
  dir = vim.fn.stdpath("config"),
  name = "herdr-send",
  lazy = false,
  config = function()
    require("herdr_send").setup({})
  end,
  keys = {
    {
      "<leader>ay",
      function()
        require("herdr_send").reference()
      end,
      mode = "n",
      desc = "Herdr: stage @ref",
    },
    {
      "<leader>ay",
      with_visual(function(opts)
        require("herdr_send").reference(opts)
      end),
      mode = "x",
      desc = "Herdr: stage @ref",
    },
    {
      "<leader>aY",
      function()
        require("herdr_send").send()
      end,
      mode = "n",
      desc = "Herdr: stage ref+code",
    },
    {
      "<leader>aY",
      with_visual(function(opts)
        require("herdr_send").send(opts)
      end),
      mode = "x",
      desc = "Herdr: stage ref+code",
    },
    {
      "<leader>ad",
      function()
        require("herdr_send").diagnostics()
      end,
      mode = "n",
      desc = "Herdr: stage diagnostics",
    },
    {
      "<leader>ad",
      with_visual(function(opts)
        require("herdr_send").diagnostics(opts)
      end),
      mode = "x",
      desc = "Herdr: stage diagnostics",
    },
    {
      "<leader>at",
      function()
        require("herdr_send").select_target()
      end,
      desc = "Herdr: pick agent",
    },
  },
}
