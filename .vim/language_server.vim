"
" Extensions to install
"
let g:coc_global_extensions = [
\ 'coc-actions',
\ 'coc-clangd',
\ 'coc-css',
\ 'coc-eslint',
\ 'coc-html',
\ 'coc-jedi',
\ 'coc-json',
\ 'coc-sh',
\ 'coc-snippets',
\ 'coc-solargraph',
\ 'coc-sql',
\ 'coc-tailwindcss',
\ 'coc-tsserver',
\ 'coc-vimlsp',
\ 'coc-yank',
\]


"
" Recommended config from main README
"
augroup cocSettings
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

set hidden " TextEdit might fail if hidden is not set.
set nobackup " Some servers have issues with backup files, see #649.
set nowritebackup
set updatetime=300 " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays
set shortmess+=c " Don't pass messages to |ins-completion-menu|.

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


"
" Keymaps
"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


"
" Set up custom text object (not actually working rn)
"
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)


"
" Statusline (add coc status to start of)
"
set statusline=%{coc#status()} " coc's loading spinner
set statusline+=\              " Separator
set statusline+=%f             " Path to the file
set statusline+=\              " Separator
set statusline+=%m             " Modified flag

set statusline+=%=             " Switch to the right side
set statusline+=%l             " Current line
set statusline+=/              " Separator
set statusline+=%L             " Total lines
set statusline+=%{get(b:,'coc_current_function','')}


"
" Code actions
"
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@


"
" Snippets
"
" Use <C-j> and <C-k> for jump to next and prev placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
vmap <C-j> <Plug>(coc-snippets-select)


"
" Clipboard manager (coc-yank)
"
nnoremap <leader>y :<C-u>CocList --auto-preview --normal --tab yank<CR>
