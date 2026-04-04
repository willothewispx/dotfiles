local function git_root()
  local path = vim.api.nvim_buf_get_name(0)
  local dir = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()
  local root = vim.fs.root(dir, ".git")
  return root or vim.uv.cwd()
end

local function system_text(cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    local err = result.stderr ~= "" and result.stderr or ("command failed: " .. table.concat(cmd, " "))
    vim.notify(err, vim.log.levels.ERROR)
    return nil
  end
  return result.stdout
end

local function send_staged_diff_to_codex()
  local cwd = git_root()
  local names = system_text({ "git", "diff", "--cached", "--name-only" }, cwd)
  if not names then
    return
  end

  names = vim.trim(names)
  if names == "" then
    vim.notify("No staged changes to summarize", vim.log.levels.WARN)
    return
  end

  local stat = system_text({ "git", "diff", "--cached", "--stat", "--no-color" }, cwd) or ""
  local diff = system_text({ "git", "diff", "--cached", "--no-color", "--no-ext-diff" }, cwd)
  if not diff then
    return
  end

  if #diff > 12000 then
    diff = diff:sub(1, 12000) .. "\n\n[diff truncated]"
  end

  local prompt = table.concat({
    "Write a concise git commit message for the currently staged changes.",
    "Prefer Conventional Commit style if it fits.",
    "Return only the commit message text, with a short subject line first and an optional body if useful.",
    "",
    "Repository: " .. cwd,
    "",
    "Staged files:",
    names,
    "",
    "Diff stat:",
    stat ~= "" and stat or "(none)",
    "",
    "Staged diff:",
    diff,
  }, "\n")

  require("sidekick.cli").send({
    name = "codex",
    focus = true,
    text = require("sidekick.text").to_text(prompt),
  })
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
        "<leader>gb",
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
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gD", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open()
        end,
        desc = "Open Neogit",
      },
      {
        "<leader>gP",
        function()
          require("neogit").open({ "push" })
        end,
        desc = "Push",
      },
      {
        "<leader>gp",
        function()
          require("neogit").open({ "pull" })
        end,
        desc = "Pull",
      },
      {
        "<leader>gm",
        send_staged_diff_to_codex,
        desc = "Generate commit message",
      },
    },
    opts = {
      integrations = {
        diffview = true,
      },
      kind = "floating",
    },
  },
}
