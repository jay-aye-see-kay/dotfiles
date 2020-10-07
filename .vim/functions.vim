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
  " Rust print next line
  autocmd FileType rust nnoremap <leader>rp "0yiwoprintln!("<C-R>0: {:?}", <C-R>0);<ESC>
  autocmd FileType rust vnoremap <leader>rp "0yoprintln!("<C-R>0: {:?}", <C-R>0);<ESC>
  " vimL print next line
  autocmd FileType vim nnoremap <leader>rp "0yiwoecho '<C-R>0: ' <C-R>0<ESC>
  autocmd FileType vim vnoremap <leader>rp "0yoecho '<C-R>0: ', <C-R>0<ESC>
augroup END

" F12 to fix syntax highlighting when needed https://vim.fandom.com/wiki/Fix_syntax_highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" TODO put this in a custom insert things mode. The only free ctrl-something
" keys in insert mode are: <C-y>, <C-b>, and <C-;>, I like <C-;>. <C-y> is
" out, going to use for clipboard.
"
" I'm thinking put an fzf menu of custom functions pop up. All the dates
" formats could be in there, plus...
augroup timestamps
  " mnemonics: date, time, now, stamp
  nnoremap <leader>dd "=strftime("%Y-%m-%d")<CR>p
  nnoremap <leader>dt "=strftime("%H:%M:%S")<CR>p
  nnoremap <leader>dn "=strftime("%Y-%m-%d %H:%M")<CR>p
  nnoremap <leader>ds "=system("date --iso-8601=seconds")<CR>p
augroup END



"
" focus floating window, if exists
"
function ToggleFloatingFocus() abort
  let visible_win_ids = nvim_tabpage_list_wins(0)
  let focused_win_id = nvim_get_current_win()

  for win_id in visible_win_ids
    let win_config = nvim_win_get_config(win_id)
    if win_config.relative ==# ''
      continue
    endif

    if win_id !=# focused_win_id
      call nvim_set_current_win(win_id)
    else
      call nvim_set_current_win(win_config.win)
    endif
  endfor
endfunction

nnoremap <C-w><C-f> :call ToggleFloatingFocus()<CR>
nnoremap <C-w>f :call ToggleFloatingFocus()<CR>
