Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'

"
" Extensions to install
"
let g:coc_global_extensions = [
\ 'coc-actions',
\ 'coc-clangd',
\ 'coc-css',
\ 'coc-emoji',
\ 'coc-eslint',
\ 'coc-html',
\ 'coc-jedi',
\ 'coc-json',
\ 'coc-prettier',
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

set nobackup " Some servers have issues with backup files, see #649.
set nowritebackup
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
nmap <silent> <leader>a :<C-u>CocCommand actions.open<CR>


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
" The second one isn't that great because it leaves the cursor before the
" pasted text. Plus the reflow jank from coc-yank is pretty bad, would prefer
" something fzf based.
nnoremap <leader>y :<C-u>CocList --auto-preview --normal --tab yank<CR>
inoremap <C-y> <C-o>:<C-u>CocList --auto-preview --normal yank<CR>


"
" Formatting and prettier
"
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap <leader>lp  :Prettier<CR>

xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lff  <Plug>(coc-format)

"
" tagbar
"
let g:vista_default_executive = 'coc'
nnoremap <silent> <leader>tb :Vista!!<CR>
let g:vista_sidebar_width = 40
let g:vista#renderer#enable_icon = 1

" we want nothing to happen on hover, but to scroll on `s`
let g:vista_echo_cursor = 0
let g:vista_echo_cursor_strategy = "scroll"

" TODO/to ask for:
" - code to markdown doesn't update tagbar
" - toc for helpfiles?

let g:vista_no_mappings = 1
augroup vistaCustomMaps
  autocmd!
  autocmd FileType vista nnoremap <buffer> <silent> <CR> :<c-u>call vista#cursor#FoldOrJump()<CR>
  autocmd FileType vista nnoremap <buffer> <silent> s    :<c-u>call vista#cursor#ShowDetail(0)<CR>
  autocmd FileType vista nnoremap <buffer> <silent> p    :<c-u>call vista#cursor#TogglePreview()<CR>
augroup end
