let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1

function! s:init_fern() abort
  " make window movements match all other buffer types
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-l> <C-w>l

  " use H and L to like h and l but change dir too
  nmap <buffer> H <Plug>(fern-action-leave)
  nmap <buffer> L <Plug>(fern-action-enter)
endfunction

augroup fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
  " covering up a quirk: w writes and closes, so wq closes an extra window
  autocmd FileType fern-renamer cnoremap <buffer> wq w
augroup END
