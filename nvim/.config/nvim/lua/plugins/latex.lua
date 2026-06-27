return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "open"
    vim.g.vimtex_view_general_options = '-a "PDF Expert" @pdf'
  end,
  keys = {
    { "<leader>Lb", "<cmd>VimtexCompile<cr>", desc = "LaTeX: Compile" },
    { "<leader>Lv", "<cmd>VimtexView<cr>", desc = "LaTeX: View PDF" },
    { "<leader>Lt", "<cmd>VimtexTocOpen<cr>", desc = "LaTeX: Table of contents" },
    { "<leader>Lo", "<cmd>VimtexCompileOutput<cr>", desc = "LaTeX: Compiler output" },
    { "<leader>Ls", "<cmd>VimtexStatus<cr>", desc = "LaTeX: Status" },
    { "<leader>Lk", "<cmd>VimtexStop<cr>", desc = "LaTeX: Stop compiler" },
    { "<leader>Lc", "<cmd>VimtexClean<cr>", desc = "LaTeX: Clean artifacts" },
  },
}
