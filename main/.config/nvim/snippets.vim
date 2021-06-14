" Expand
imap <expr> <C-j>  vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-j>'
smap <expr> <C-j>  vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-j>'
" Jump forward or backward
imap <expr> <C-l>  vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
smap <expr> <C-l>  vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
imap <expr> <C-h>  vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
smap <expr> <C-h>  vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-h>'

inoremap <silent><expr> <CR> compe#confirm('<CR>')

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:vsnip_snippet_dir = "$HOME/.config/nvim/vsnip"

" Avoid showing message extra message when using completion
set shortmess+=c
" }}}
