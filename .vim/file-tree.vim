Plug 'lambdalisue/fern.vim'

" open or focus drawer (if pressed from outside that focus)
nnoremap <leader>e :Fern . -drawer -reveal=% -width=40<cr>

function! s:init_fern() abort
  " make window movements work as expected
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-l> <C-w>l

  nnoremap <buffer> r <Plug>(fern-action-reload)
  nnoremap <buffer> <leader>e :Fern . -drawer -toggle<cr>
endfunction

augroup fernCustom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
