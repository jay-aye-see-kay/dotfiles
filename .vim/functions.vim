"
" Misc small custom functions
"

augroup printDebugMacros
  autocmd!
  " JS/TS: print next line
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact nnoremap <leader>rp "0yiwoconsole.log('<C-R>0', <C-R>0);<ESC>
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact vnoremap <leader>rp "0yoconsole.log('<C-R>0', <C-R>0);<ESC>
  " Python print next line
  autocmd FileType python nnoremap <leader>rp "0yiwoprint('<C-R>0', <C-R>0)<ESC>
  autocmd FileType python vnoremap <leader>rp "0yoprint('<C-R>0', <C-R>0)<ESC>
  " Ruby print next line
  autocmd FileType ruby nnoremap <leader>rp "0yiwoputs '<C-R>0: ' + <C-R>0<ESC>
  autocmd FileType ruby vnoremap <leader>rp "0yoputs '<C-R>0: ' + <C-R>0<ESC>
  " Shell print next line
  autocmd FileType sh nnoremap <leader>rp "0yiwoecho "<C-R>0: $<C-R>0"<ESC>
  autocmd FileType sh vnoremap <leader>rp "0yoecho "<C-R>0: $<C-R>0"<ESC>
augroup END

" F12 to fix syntax highlighting when needed https://vim.fandom.com/wiki/Fix_syntax_highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
