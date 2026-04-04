return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open

    opts.extensions = opts.extensions or {}
    opts.extensions.live_grep_args = vim.tbl_deep_extend("force", opts.extensions.live_grep_args or {}, {
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-f>"] = actions.to_fuzzy_refine,
        },
      },
    })
    opts.defaults = opts.defaults or {}
    opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
      i = {
        ["<C-t>"] = open_with_trouble,
      },
      n = {
        ["<C-t>"] = open_with_trouble,
      },
    })

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
        })
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Grep in files with args",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Find in current file",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find help",
    },
  },
  opts = {
    defaults = {
      path_display = { "full" },
      file_ignore_patterns = {
        "%.git/",
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob",
        "!.git/*",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      live_grep_args = {
        auto_quoting = true,
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
  },
}
