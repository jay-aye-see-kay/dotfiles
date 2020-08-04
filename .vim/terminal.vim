" double ctrl-backslash to escape from terminal mode
tnoremap <C-\><C-\> <C-\><C-n>
" ctrl-c, ctrl-p, ctrl-n, enter should all be passed through from normal mode
augroup termPassthroughCommands
  au!
  au BufEnter term://*  nnoremap <C-C> i<C-C><C-\><C-n>
  au BufLeave term://*  nnoremap <C-C> <C-C>
  au BufEnter term://*  nnoremap <C-P> i<C-P><C-\><C-n>
  au BufLeave term://*  nnoremap <C-P> <C-P>
  au BufEnter term://*  nnoremap <C-N> i<C-N><C-\><C-n>
  au BufLeave term://*  nnoremap <C-N> <C-N>
  au BufEnter term://*  nnoremap <CR> i<CR><C-\><C-n>
  au BufLeave term://*  nnoremap <CR> <CR>
augroup END
" keep 'other' terminal cursor visible when in normal mode
hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#5f875f cterm=NONE gui=NONE
