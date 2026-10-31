" Lightweight vim for machines without nvim (e.g. HPC servers): no plugins,
" light background to match the Ghostty Dayfox theme.

" Having a ~/.vimrc stops vim from loading defaults.vim; without it 'ttimeout'
" is off (Esc waits up to 1s) and vim 8 also leaves 'backspace' empty. Some
" distros set skip_defaults_vim in the system vimrc.
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set number relativenumber cursorline
set hlsearch ignorecase smartcase
set mouse=a
set expandtab shiftwidth=4 tabstop=4
set laststatus=2
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

" Bars in tmux's status bar colors; vim's defaults are reverse video, which
" turns them into dark blocks on a light background. Vim takes the attributes
" from cterm= even with termguicolors, so set both.
set fillchars+=vert:│
highlight StatusLine   guifg=#3d2b5a guibg=#ede6df cterm=bold gui=bold
highlight StatusLineNC guifg=#7a6f66 guibg=#ede6df cterm=NONE gui=NONE
highlight VertSplit    guifg=#d3c7bb guibg=NONE    cterm=NONE gui=NONE
highlight TabLineFill  guibg=#ede6df cterm=NONE gui=NONE
highlight TabLine      guifg=#7a6f66 guibg=#ede6df cterm=NONE gui=NONE
highlight TabLineSel   guifg=#9a4a02 guibg=#f3e1cd cterm=bold gui=bold

" netrw (:Ex, :Vex) as a tree, without the banner
let g:netrw_banner=0
let g:netrw_liststyle=3
