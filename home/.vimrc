imap <C-BS> <C-W>

" Trim whitespace
noremap <Leader>rws :%s:\s\+$::<CR>:let @/=''<cr>

" bind leader to space
let mapleader = " "

" populate icons dictionary to powerline symbols
let g:airline_powerline_fonts = 1

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

set number relativenumber
set paste
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set number ruler
set autoindent smartindent
set clipboard+=unnamed
set wildmode=longest,list,full
set wildmenu
syntax enable


call plug#begin()
call plug#end()


