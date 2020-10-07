Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" disable `s`, use `cl` instead
nnoremap s <nop>

nnoremap sb :Buffer<CR>
nnoremap sh :History<CR>
nnoremap sz :FZF<CR>
nnoremap sg :GFiles<CR>
nnoremap sa :Rg<CR>
nnoremap sl :BLines<CR>
nnoremap sc :Commands<CR>
nnoremap sn :Notes<CR>
" shows files edited on current branch (diffed with master)
command! -bang EditedFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source': 'git diff --name-only `git merge-base origin/master HEAD`' })))
nnoremap se :EditedFiles<CR>
" Search word Under cursor/selection in pwd
nnoremap su :Rg <C-r><C-w><CR>
vnoremap su "0y:Rg <C-R>0<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS = "--layout=reverse"
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85,
      \ 'highlight': 'Question', 'border': 'sharp' } }

" grep all text in my wiki
command! -bang -nargs=* Notes
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '
  \   .shellescape(<q-args>).' '.g:vimwiki_list[0]['path'], 1,
  \   fzf#vim#with_preview(), <bang>0)

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
