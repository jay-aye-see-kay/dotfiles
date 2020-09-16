Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

nnoremap <leader>fb :Buffer<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fz :FZF<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fa :Rg<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fc :Commands<CR>
" grep all text in my wiki (TODO add preview window)
nnoremap <leader>fw :call fzf#vim#ag('', { 'dir':  g:vimwiki_list[0]['path'] })<CR>
" shows files edited on current branch (diffed with master)
command! -bang EditedFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source': 'git diff --name-only `git merge-base origin/master HEAD`' })))
nnoremap <leader>fe :EditedFiles<CR>
" global search word under cursor/selection
nnoremap <leader>ff "0yiw:Rg <C-R>0<CR>
vnoremap <leader>ff "0y:Rg <C-R>0<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS = "--layout=reverse"
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85,
      \ 'highlight': 'Question', 'border': 'sharp' } }

augroup fzfDefaultEscapeBehavior
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <ESC> <ESC>
augroup END

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
" see https://github.com/junegunn/fzf/blob/master/README-VIM.md#configuration
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" fuzzy git
nnoremap <leader>gfl :Commits<CR>
nnoremap <leader>gfc :BCommits<CR>
