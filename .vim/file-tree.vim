Plug 'lambdalisue/fern.vim'

" open or focus drawer (if pressed from outside that focus)
nnoremap <silent> <leader>e :Fern . -drawer -reveal=% -width=40<cr>

function! s:init_fern() abort
  " allow <leader>e to close drawer from inside it
  nnoremap <silent><buffer> <leader>e :Fern . -drawer -toggle<cr>

  " make window movements match the rest of my vim
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-l> <C-w>l

  " this seems like a better use or r
  nnoremap <buffer> r <Plug>(fern-action-reload)
endfunction

augroup fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
  " covering up a quirk: w writes and closes, so wq closes an extra window
  autocmd FileType fern-renamer cnoremap <buffer> wq w
augroup END
