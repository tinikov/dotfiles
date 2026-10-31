" Lightweight vim for machines without nvim (e.g. HPC servers): no plugins,
" light background to match the Ghostty Dayfox theme.

syntax on
filetype plugin indent on
set number relativenumber cursorline
set hlsearch incsearch ignorecase smartcase
set scrolloff=5
set mouse=a
set expandtab shiftwidth=4 tabstop=4
set laststatus=2 ruler showcmd
set wildmenu
set encoding=utf-8
set nowrap
set background=light

if has('termguicolors')
    " vim 8.0 doesn't set these for TERM=xterm-ghostty / tmux-256color;
    " without them termguicolors turns all colors off
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" netrw (:Ex, :Vex) as a tree, without the banner
let g:netrw_banner=0
let g:netrw_liststyle=3
