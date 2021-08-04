" vimwiki
let g:vimwiki_list = [{'path': '~/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki.md'}]
let g:vimwiki_conceallevel = 0

" 'list toggle' as ctrl space I use to clear notifications
nnoremap glt :VimwikiToggleListItem<CR>
vnoremap glt :VimwikiToggleListItem<CR>

let g:vimwiki_key_mappings =
  \ {
  \   'headers': 0,
  \   'links': 0,
  \   'html': 0,
  \ }

augroup naturalMovementInTextFiles
  autocmd!
  autocmd FileType vimwiki nnoremap <buffer> <cr> <cmd>VimwikiFollowLink<cr>
  autocmd FileType text,markdown,vimwiki nnoremap j gj
  autocmd FileType text,markdown,vimwiki nnoremap k gk
  autocmd FileType text,markdown,vimwiki setlocal wrap
augroup END
