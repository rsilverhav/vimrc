set encoding=utf-8
"
" Loading Vundle and other plugins
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Custom plugins
Plugin 'easymotion/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Valloric/YouCompleteMe'
Plugin 'lyuts/vim-rtags'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'tpope/vim-fugitive'
Plugin 'mhartington/oceanic-next'
Plugin 'kien/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"
" File tab completion
"
set wildmode=longest,list,full
set wildmenu
set wildignorecase

"
" Util
"
set mouse=a
set number
set backspace=indent,eol,start
set list
set hlsearch
set tw=500

"
" Colors
"
" Custom colorscheme
syntax enable
set t_Co=256
if (has("termguicolors"))
  set termguicolors
endif

colorscheme OceanicNext
highlight SpellBad cterm=None guibg=red guifg=white
highlight NonText guifg=#335577
highlight ExtraWhitespace ctermbg=red

match ExtraWhitespace /\s\+$/
set colorcolumn=120
set fillchars+=vert:│
highlight VertSplit ctermbg=white ctermfg=black
highlight CursorLine cterm=None ctermbg=238

" NerdTree
map <F12> :NERDTree <CR>
autocmd FileType nerdtree setlocal nolist


"
" Status Line
"
set laststatus=2
set statusline=%f         " Path to the file
set statusline+=%m        " Shows if file is modified
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines


"
" Tabs
"
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent


"
" Helper Functions
"

function! GdbCurrent()
  let curr_file=expand("%:p")
  let gdb_arg=' -ex="b ' . expand("%:t") . ':' . line(".") . '" -ex="r"'
  let command=system("debug_gdb_str " . curr_file)
  call term_start(command . gdb_arg)
endfunction

function! FindCurrInNerdtree()
  if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1 && expand("%:p") =~ getcwd()
    let last_win = win_getid()
    NERDTreeFind
    call win_gotoid(last_win)
  endif
endfunction

function! OpenHeaderSource()
  let filename=expand('%:t')
  let isSrc=matchstr(filename, 'cc$')
  " If this is true the file is a header file
  if empty(isSrc)
    let newfilename = substitute(filename, "h$", "cc", "")
  else
    let newfilename = substitute(filename, "cc$", "h", "")
  endif
  vsp
  execute "find " . newfilename
endfunction


"
"
" Rtags
"
let g:rtagsUseDefaultMappings = 0
noremap <F1> :call rtags#FindRefsCallTree()<CR>
noremap <F2> :call rtags#JumpTo(g:V_SPLIT)<CR>
noremap <F3> :call rtags#JumpTo(g:SAME_WINDOW)<CR>
noremap <F4> :call rtags#FindVirtuals()<CR>
noremap <F5> :call rtags#ReindexFile()<CR>
noremap <F6> :call rtags#FindRefs()<CR>
noremap <Leader>G :call rtags#FindRefs()<CR>


"
" Auto cmds
"
autocmd VimEnter * if $PWD=~'ppf\/ppe' | set path=$PWD/** | endif
autocmd BufEnter * call FindCurrInNerdtree()


"
" Loading extra files
"
for f in split(glob('~/.vim/my_extras/*.vim'), '\n')
  exe 'source' f
endfor


"
" CtrlP
"
let g:ctrlp_by_filename = 1

"
" Keybinds
"
let mapleader=" "
nnoremap <Leader>g :CtrlPBufTag<CR>
nnoremap <Leader>c :CtrlPCurWD<CR>
nnoremap <Leader>* :exe('vimgrep ' . expand("<cword>") . ' **/* \| copen')<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-n> :tablast<CR>:tabnew<CR>
map <Leader> <Plug>(easymotion-prefix)
nnoremap n nzz
nnoremap N Nzz

noremap <C-c> <ESC>
nnoremap <C-c> :ccl <CR>
nnoremap <C-h> :call OpenHeaderSource() <CR>
nnoremap <C-f> :NERDTreeFind <CR>
nnoremap <Leader>t :call CreateTp() <CR>
nnoremap <Leader>T :call CreateTpRef() <CR>
nnoremap <Leader>r :! python3 % <CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>N :cprevious<CR>
nnoremap <Leader>C :CtrlPMRUFiles<CR>
nnoremap <Leader>d :call GdbCurrent()<CR>
