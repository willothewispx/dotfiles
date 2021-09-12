local npairs = require('nvim-autopairs')
local remap = vim.api.nvim_set_keymap

npairs.setup({
    check_ts = true, -- treesitter support
    ts_config = {
        lua = {'string'}, -- it will not add pair on that treesitter node
        javascript = {'template_string'},
        java = false, -- don't check treesitter on java
    }
})

require('nvim-treesitter.configs').setup {
    autopairs = {enable = true}
}

-- Mapping of <CR> with nvim-compe
_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end

remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
