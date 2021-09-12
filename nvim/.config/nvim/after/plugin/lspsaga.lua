require('lspsaga').init_lsp_saga()

---
-- Colors
---

-- Code action
vim.cmd([[highlight link LspSagaCodeActionTitle Title]])
vim.cmd([[highlight link LspSagaCodeActionContent Green]])
vim.cmd([[highlight link LspSagaCodeActionBorder Blue]])
vim.cmd([[highlight link LspSagaLightBulb Green]])

-- Rename
vim.cmd([[highlight link LspSagaBorderTitle Title]])
vim.cmd([[highlight link LspSagaRenamePromptPrefix Green]])
vim.cmd([[highlight link LspSagaRenameBorder Blue]])

-- Diagnostics
vim.cmd([[highlight link LspSagaDiagnosticHeader Title]])
vim.cmd([[highlight link LspSagaDiagnosticBorder Purple]])
vim.cmd([[highlight link LspSagaDiagnosticTruncateLine Purple]])
