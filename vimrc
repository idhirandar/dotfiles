" ==============================================================================
"                          Vim Configuration (.vimrc)
" ==============================================================================

" Leader key (must be set early)
let mapleader = ","

" -----------------------------------------------------------------------------
" Plugin Manager Setup (vim-plug)
" -----------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Statusline / Tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color schemes
Plug 'tomasiser/vim-code-dark'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sjl/badwolf'

" File explorer
Plug 'preservim/nerdtree'

" Auto-completion popup
Plug 'vim-scripts/AutoComplPop'

" Table editing
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'

call plug#end()

" -----------------------------------------------------------------------------
" General Appearance & Behavior
" -----------------------------------------------------------------------------
colorscheme codedark                " Default color scheme
set termguicolors                   " Enable true colors in terminal
set cursorline                      " Highlight current line
set number                          " Show line numbers
set formatoptions=cro               " Control automatic formatting (comments, etc.)

" Cursor highlighting
highlight CursorLine guibg=#3E3D32   " Subtle background for current line
highlight Cursor     guibg=#A6E22E   " Bright cursor color

" -----------------------------------------------------------------------------
" Airline Configuration
" -----------------------------------------------------------------------------
let g:airline_theme = 'codedark'            " Match overall theme
let g:airline_powerline_fonts = 1           " Use powerline-patched fonts
let g:airline_extensions = []               " Disable all extensions for minimalism
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" -----------------------------------------------------------------------------
" NERDTree Configuration
" -----------------------------------------------------------------------------
" Smart F6 toggle:
" - If NERDTree is open → close it
" - If a file is loaded → find it in NERDTree
" - Otherwise → open NERDTree at current directory
nnoremap <silent> <expr> <F6> 
      \ g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" :
      \ bufexists(expand('%')) ? ":NERDTreeFind<CR>" : ":NERDTree<CR>"

" Open files in new tabs by default when pressing Enter
let NERDTreeCustomOpenArgs = {'file': {'where': 't'}}

" -----------------------------------------------------------------------------
" vim-table-mode Configuration
" -----------------------------------------------------------------------------
let g:table_mode_corner_corner = '+'        " Corner character for tables
let g:table_mode_header_fillchar = '='      " Fill character for headers

" Smart abbreviations for quick table mode toggle
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

" || at start of line → enable table mode and insert basic table separator
inoreabbrev <expr> <bar><bar>
      \ <SID>isAtStartOfLine('\|\|') ?
      \ '<C-o>:TableModeEnable<CR><bar><space><bar><left><left>' : '<bar><bar>'

" __ at start of line → disable table mode
inoreabbrev <expr> __
      \ <SID>isAtStartOfLine('__') ?
      \ '<C-o>:silent! TableModeDisable<CR>' : '__'

" -----------------------------------------------------------------------------
" End of Configuration
" -----------------------------------------------------------------------------
" To enable table mode quickly: type ',tm' (or use || at line start)
" ==============================================================================
"
"
set ignorecase smartcase    " Case-insensitive search unless uppercase used
set incsearch               " Show matches while typing
set hlsearch                " Highlight all matches
nnoremap <silent> <leader>/ :nohlsearch<CR>  " Clear highlight with ,/

set expandtab               " Use spaces instead of tabs
set shiftwidth=4            " Indent with 4 spaces
set softtabstop=4
set tabstop=4
set smartindent             " Auto-indent new lines

set hidden                  " Allow switching buffers without saving
set autoread                " Auto-reload files changed outside Vim
set wildmenu                " Better command-line completion
set wildmode=longest:full,full
set scrolloff=5             " Keep 5 lines visible above/below cursor
set sidescrolloff=10
set confirm                 " Ask to save instead of failing commands

set updatetime=300          " Faster CursorHold events (good for gitgutter, etc.)
set shortmess+=c            " Avoid 'pattern not found' messages
set signcolumn=yes          " Always show sign column (prevents shifting)

set splitbelow              " New horizontal splits go below
set splitright              " New vertical splits go right
" Easier split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Y yanks to end of line (consistent with D, C)
nnoremap Y y$

" Quick save with ,w
nnoremap <leader>w :w<CR>

set backup                  " Enable backups
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile                " Persistent undo

" Create directories if they don't exist
silent! call mkdir($HOME.'/.vim/backup', 'p')
silent! call mkdir($HOME.'/.vim/swap', 'p')
silent! call mkdir($HOME.'/.vim/undo', 'p')


