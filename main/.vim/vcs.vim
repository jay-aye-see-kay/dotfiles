Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

augroup commitMessageSettings
  autocmd!
  autocmd FileType gitcommit setlocal spell
augroup end

let g:gitgutter_map_keys = 0
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap <leader>gz :GitGutterFold<CR>
nnoremap <leader>gp :GitGutterPreviewHunk<CR>

nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap <leader>gs :Gstatus<CR><C-w>T
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gl :Gclog<CR>
nnoremap <leader>gb :Gblame<CR>
