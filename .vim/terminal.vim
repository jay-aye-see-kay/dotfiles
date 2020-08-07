function! s:terminal_config() abort
  " stops terminal side scrolling
  setlocal nonumber norelativenumber signcolumn=no

  " ctrl-c, ctrl-p, ctrl-n, enter should all be passed through from normal mode
  nnoremap <buffer> <C-C> i<C-C><C-\><C-n>
  nnoremap <buffer> <C-P> i<C-P><C-\><C-n>
  nnoremap <buffer> <C-N> i<C-N><C-\><C-n>
  nnoremap <buffer> <CR> i<CR><C-\><C-n>
endfunction

augroup termConfig
  autocmd!
  autocmd TermOpen * call s:terminal_config()
augroup END

" double ctrl-backslash to escape from terminal mode
tnoremap <C-\><C-\> <C-\><C-n>

" open new term in split
nnoremap <leader>ts <C-w><C-s>:terminal<CR>
nnoremap <leader>tv <C-w><C-v>:terminal<CR>

" keep 'other' terminal cursor visible when in normal mode
hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#5f875f cterm=NONE gui=NONE
