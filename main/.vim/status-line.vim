Plug 'itchyny/lightline.vim'

let g:lightline = {
\   'colorscheme': 'one',
\   'active': {
\     'left': [ [ 'mode', 'paste' ],
\               [ 'cocstatus', 'readonly', 'gitbranch', 'relativepath', 'modified' ] ]
\   },
\   'inactive': {
\     'left': [ [ 'relativepath' ] ]
\   },
\   'component_function': {
\     'cocstatus': 'coc#status',
\     'gitbranch': 'FugitiveHead'
\   },
\ }
