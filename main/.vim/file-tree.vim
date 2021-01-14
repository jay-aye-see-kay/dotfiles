Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/nerdfont.vim'

let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1

function! s:init_fern() abort
  " allow <leader>e to close drawer from inside it
  nnoremap <silent><buffer> <leader>e :Fern . -drawer -toggle<cr>

  " make window movements match the rest of my vim
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-l> <C-w>l

  " this seems like a better use of r
  nnoremap <buffer> r <Plug>(fern-action-reload)
endfunction

augroup fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
  " covering up a quirk: w writes and closes, so wq closes an extra window
  autocmd FileType fern-renamer cnoremap <buffer> wq w
augroup END

function s:fern_open_project_view(drawer) abort
  let project_dir = GetProjectDir()
  let current_file = expand("%:p")
  if a:drawer
    execute printf('Fern %s -reveal=%s -drawer -width=30', fnameescape(project_dir), fnameescape(current_file))
  else
    execute printf('Fern %s -reveal=%s', fnameescape(project_dir), fnameescape(current_file))
  endif
endfunction

" open Fern as Window
nnoremap <silent> <leader>fw :call <SID>fern_open_project_view(0)<CR>
" open Fern as Drawer
nnoremap <silent> <leader>fd :call <SID>fern_open_project_view(1)<CR>
