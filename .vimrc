"Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
Plug 'tpope/vim-sensible'
"
"===============================================THEMING
"Plug 'crusoexia/vim-monokai'
Plug 'mcmartelle/vim-monokai-bold'
"Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }      
Plug 'sjl/badwolf'
Plug 'tomasiser/vim-code-dark'

"===============================================vim NERDTree config
Plug 'preservim/nerdtree' |
let mapleader = ","
"nmap <F6> :NERDTreeToggle<CR>                  =========NERDTree F6 key config
nnoremap <silent> <expr> <F6> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

"let NERDTreeMapOpenInTab='<ENTER>'
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

Plug 'nathanaelkane/vim-indent-guides'
"let g:indent_guides_guide_size = 1
"let g:indent_guides_color_change_percent = 3
"let g:indent_guides_enable_on_vim_startup = 1

Plug 'thaerkh/vim-indentguides'
let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeQuitOnOpen = 1

"=====================================================================vim-table_plugin
Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='
"let g:table_mode_corner="|"

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
"ending of vim-table_plugin comment

"========================================----------------------------------=vim-autocompletion
Plug 'jiangmiao/auto-pairs' 

"===========================================================file search machenizem
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" =========================================================vim airline theme and Airline plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1"
let g:airline_theme='dracula'
"let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

"Automatically show Vim's complete menu while typing
Plug 'vim-scripts/AutoComplPop'


" Initialize plugin system
call plug#end()

"User System clipboarn
"set clipboard^=unnamed,unnamedplus
set clipboard+=xclipboard
"if has('unnamedplus')
"	  set clipboard=unnamed,unnamedplus
"  endif
"

"Vertically Center Document when entering insert mode
"autocmd InsertEnter * norm zz


"Enable and disable auto comment
"map <leader>c :setlocal formatoptions-=cro<CR>
"map <leader>C :setlocal formatoptions=cro<CR>

"set number moving relavite number 
"set number relativenumber
"set number relativenumber 
set number

"set tergui color
set termguicolors

set cursorline
"set cursorcolumn
"let g:netrw_banner = 0

"Autocompeltion
"set wildmode=longest,list,full 
"
"Vim Find work ignorecase
set ignorecase
set smartcase

"search highlight
set hlsearch 

"colorcolumn ruler highlight
set colorcolumn=200

"Disable Automatically Commenting NextLine
set formatoptions-=cro

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Visual Mode Orange Background, Black Text
hi Visual          guifg=#000000 guibg=#FD971F

" Default Colors for CursorLine.
highlight CursorLine guibg=#3E3D32
highlight Cursor guibg=#A6E22E

" Change Color when entering Insert Mode
autocmd InsertEnter * highlight  CursorLine guibg=#323D3E
autocmd InsertEnter * highlight  Cursor guibg=#00AAFF

" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight  CursorLine guibg=#3E3D32
autocmd InsertLeave * highlight  Cursor guibg=#A6E22E

highlight  CursorLine ctermbg=Yellow ctermfg=None
autocmd InsertEnter * highlight  CursorLine ctermbg=Green ctermfg=Red
colorscheme badwolf
