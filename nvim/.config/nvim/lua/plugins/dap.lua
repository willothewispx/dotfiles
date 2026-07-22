local function conditional_breakpoint()
  local condition = vim.fn.input("Breakpoint condition: ")
  if condition == "" then
    return
  end

  require("dap").set_breakpoint(condition)
end

local function setup_signs()
  local signs = {
    DapBreakpoint = { text = "●", texthl = "DiagnosticError" },
    DapBreakpointCondition = { text = "◆", texthl = "DiagnosticWarn" },
    DapBreakpointRejected = { text = "○", texthl = "DiagnosticError" },
    DapLogPoint = { text = "◆", texthl = "DiagnosticInfo" },
    DapStopped = { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" },
  }

  for name, sign in pairs(signs) do
    vim.fn.sign_define(name, sign)
  end
end

local function setup_ui_lifecycle(dap, dapui)
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },
  keys = {
    {
      "<F7>",
      function()
        require("dap").step_into()
      end,
      desc = "Debugger: Step into",
    },
    {
      "<F8>",
      function()
        require("dap").step_over()
      end,
      desc = "Debugger: Step over",
    },
    {
      "<F9>",
      function()
        require("dap").continue()
      end,
      desc = "Debugger: Start / continue",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debugger: Toggle breakpoint",
    },
    {
      "<leader>dB",
      conditional_breakpoint,
      desc = "Debugger: Conditional breakpoint",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "Debugger: Step out",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      desc = "Debugger: Pause",
    },
    {
      "<leader>dx",
      function()
        require("dap").terminate()
      end,
      desc = "Debugger: Terminate",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Debugger: Toggle UI",
    },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "x" },
      desc = "Debugger: Evaluate",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Debugger: Toggle REPL",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debugger: Run last",
    },
    {
      "<leader>dt",
      function()
        require("dap-go").debug_test()
      end,
      desc = "Debugger: Go test",
    },
    {
      "<leader>dT",
      function()
        require("dap-go").debug_last_test()
      end,
      desc = "Debugger: Last Go test",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
      floating = {
        border = "rounded",
      },
    })
    require("dap-go").setup()
    setup_signs()
    setup_ui_lifecycle(dap, dapui)
  end,
}
