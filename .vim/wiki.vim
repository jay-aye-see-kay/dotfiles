Plug 'vimwiki/vimwiki'

" vimwiki
let g:vimwiki_list = [{'path': '~/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki.md'}]
let g:vimwiki_conceallevel = 0

" 'list toggle' as ctrl space I use to clear notifications
nnoremap glt :VimwikiToggleListItem<CR>
vnoremap glt :VimwikiToggleListItem<CR>

augroup naturalMovementInTextFiles
  autocmd!
  autocmd FileType text,markdown,vimwiki nnoremap j gj
  autocmd FileType text,markdown,vimwiki nnoremap k gk
  autocmd FileType text,markdown,vimwiki set wrap
augroup END
