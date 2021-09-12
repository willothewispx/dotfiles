"  TODO: Change to lua
set shortmess+=c

au FileType * set fo+=c fo-=o fo+=r
set list
set listchars=eol:↴
set listchars+=tab:│⋅
set listchars+=trail:•
set listchars+=extends:❯
set listchars+=precedes:❮
set listchars+=nbsp:_
" set listchars+=space:
set showbreak=↳⋅

" Show menu when using :find *.lua <TAB>
set path+=**
set wildmode=longest,full
set wildmenu
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

" Toggle quickfix
function! QuickFixIsOpen()
  let l:result = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
  return !empty(l:result)
endfunction
nnoremap <C-q> :<C-R>=QuickFixIsOpen() ? "cclose" : "copen"<CR><CR>
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
