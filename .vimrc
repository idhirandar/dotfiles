
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
"   
"| start plugin section | put any plugin in between |
"+======================+===========================+
call plug#begin('~/.vim/plugged')

"| airline plugin | airline_theme | airline config |
"+================+===============+================+
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='codedark'
let g:airline_powerline_fonts = "1"
let g:airline_extensions = []
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


"
"| multiplele DIFFRENT THEME FOR Vim | vim-code-dark | dracula | badwolf |
"+===================================+===============+=========+=========+
Plug 'tomasiser/vim-code-dark'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sjl/badwolf'

"| NERDTree(file explorer) plugin | key binding F6 |
"+================================+================+
Plug 'preservim/nerdtree' |
let mapleader = ","
"nmap <F6> :NERDTreeToggle<CR>                      ###################### NERDTree F6 key config
nnoremap <silent> <expr> <F6> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
"let NERDTreeMapOpenInTab='<ENTER>                  ##################### open in newtab
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}


"| "Automatically show Vim's complete menu while typing | popup completion |
"+======================================================+==================+
"Automatically show Vim's complete menu while typing
Plug 'vim-scripts/AutoComplPop'

"| vim-table_mode plugin | and confing key binding {,tm} | enable table mode |
"+=======================+===============================+===================+
Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
"let g:table_mode_corner="|"
"To start using the plugin in the on-the-fly = ',' to have ( , t m).

"| ...................................................................................................... |
"+========================================================================================================+
" Initialize plugin system
call plug#end()

colorscheme codedark

"set tergui color
set termguicolors

set cursorline
set number 

" Default Colors for CursorLine
highlight CursorLine guibg=#3E3D32
highlight Cursor guibg=#A6E22E

"=================================================================================TEST AREA
"
set formatoptions=cro
