call plug#begin('~/.local/share/nvim/plugged')

Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim'

Plug 'mhartington/oceanic-next'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'mxw/vim-jsx'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'AlessandroYorba/Sierra'

call plug#end()

"
" Util
"
set mouse=a
set number
set backspace=indent,eol,start
set list
set hlsearch

"
"
" File tab completion
"
set wildmode=longest,list,full
set wildmenu
set wildignorecase


"
" Tabs to spaces
"
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent


"
"
" Colors
"
syntax on
"color OceanicNext
let g:sierra_Sunset = 1
colorscheme sierra 
highlight Search gui=bold
highlight SpellBad cterm=None
highlight Label ctermfg=Gray
highlight Statement ctermfg=108
highlight preproc ctermfg=Gray


"
" Helper functions
"
function! Ctrlf()
  let query = input('Search: ')
  silent execute "grep! -rI " . shellescape(query) . " ."
  copen
  redraw!
endfunction

function! FindCurrInNerdtree()
  if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1 && expand("%:p") =~ getcwd()
    let last_win = win_getid()
    NERDTreeFind
    call win_gotoid(last_win)
  endif
endfunction

command! Config vsp ~/.config/nvim/init.vim


function! OpenCssTsx()
  let orig_filename = expand("%:t")
  let from = orig_filename =~ ".tsx" ? "tsx" : "css"
  let to = orig_filename =~ ".tsx" ? "css" : "tsx"
  let filename = substitute(orig_filename, from, to, "")
  execute "vsp ". expand("%:p:h") . "/" . filename
endfunction


"
" CtrlP config
"
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,node_modules
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|node_modules'
let g:ctrlp_by_filename = 1
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_extensions = ['ts']
command! CtrlPTS call ctrlp#init(ctrlp#ts#id())


"
" NERDTree config
"
let NERDTreeChDirMode=2

if !has('gui_running')
  let g:NERDTreeDirArrowExpandable = "+"
  let g:NERDTreeDirArrowCollapsible = "~"
endif


"
" Airline config
"
let g:airline_powerline_fonts = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'


"
" ALE config
"
let b:ale_fixers = {'typescript': ['prettier']}
let g:ale_fix_on_save=1

"
" Autocmds
"
autocmd FileType nerdtree setlocal nolist
autocmd FileType typescript setlocal completeopt+=menu,preview


"
" Typescript config
"
let g:deoplete#enable_at_startup = 1

"
" Keybinds
"
let mapleader=" "
noremap <C-c> <ESC>
nnoremap <C-c> :ccl<CR>
nnoremap <Leader>r :! python3 %<CR>
nnoremap <Leader>c :CtrlP<CR>

nnoremap ¬¥ $
nnoremap - $
vnoremap - $
nnoremap <C-f> :call Ctrlf()<CR>
map <Leader> <Plug>(easymotion-prefix)
nnoremap <C-t> :tabnew<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <Leader>t :CtrlPTS<CR>
nnoremap <Leader>s :call OpenCssTsx()<CR>
nnoremap <Leader>v :ALEFix prettier<CR>

map <C-l> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
