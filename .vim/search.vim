Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

nnoremap <leader>fb :Buffer<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fz :FZF<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fc :Commands<CR>
" grep all text in my wiki (TODO add preview window)
nnoremap <leader>fw :call fzf#vim#ag('', { 'dir':  g:vimwiki_list[0]['path'] })<CR>
" shows files edited on current branch (diffed with master)
command! -bang EditedFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source': 'git diff --name-only `git merge-base origin/master HEAD`' })))
nnoremap <leader>fe :EditedFiles<CR>
" global search word under cursor/selection
nnoremap <leader>ff "0yiw:Ag <C-R>0<CR>
vnoremap <leader>ff "0y:Ag <C-R>0<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS = "--layout=reverse"

" fzf in floating window https://github.com/junegunn/fzf.vim/issues/664
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

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
