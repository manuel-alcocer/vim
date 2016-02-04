set nocompatible
set number
set mouse=a
syntax on
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree.git'
Plugin 'scrooloose/syntastic'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-surround.git'

call vundle#end()
execute pathogen#infect()
filetype plugin indent on

set encoding=utf-8

let g:nerdtree_tabs_open_on_console_startup=0

"" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
set laststatus=2

"" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = '/usr/bin/python2'

"""""""""""""""""""""""""""""""""""""""""""""""""""
"" neocomplete
let g:neocomplete#enable_at_startup = 1
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
"  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

""""""""""""""""""""""""""""""""""""""""""""""""""

"" auto-pairs
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'
"""""""""""""""

""" Funciones de ejecuci√≥n
" Ejecuta python2 y python3
function! RunPython()
	nnoremap <F5> :w! <bar> :!python2 '%:p'<CR>
    nnoremap <F6> :w! <bar> :!python3 '%:p'<CR>
endfunction

" Ejecuta mysql 
function! RunMysql()
    """ REGISTROS A CREAR:
    """""""""""""""""""""""
    """ Registro h: host de  mysql
    """ Registro u: usuario
    "" Registro d: nombre de la base de datos
    "" Registro p: password
    """
    """ Ejecuta la linea bajo el cursor de forma local
	nnoremap <F4> "eyy <bar> :!mysql -u<C-r>u --password="<C-r>p" --database="<C-r>d" --execute="<C-r>e"<CR>
    """ Ejecuta la linea bajo el cursor de forma remota
	nnoremap <F7> "eyy <bar> :lexpr system("mysql --host=\"<C-r>h\" -u<C-r>u --password=\"<C-r>p\" --database=\"<C-r>d\" --execute=\"<C-r>e\"") \| silent redraw! \| lopen<CR>
    """ Ejecuci√≥n del fichero en equipo local
	nnoremap <F5> :w! <bar> :!mysql -u<C-r>u --password="<C-r>p" < '%:t'<CR>
    """ Ejecuci√≥n del fichero de forma remota
	nnoremap <F8> :w! <bar> :!mysql --host="<C-r>h" -u<C-r>u --password="<C-r>p" < '%:t'<CR>
	""" Muestra en una ventana el fichero en local
	nnoremap <F6> :w! <bar> :lexpr system("mysql -u<C-r>u --password=\"<C-r>p\" < ".expand("%:t")) \| silent redraw! \| lopen<CR>
    """ Muestra en una ventana el fichero en remoto
	nnoremap <F9> :w! <bar> :lexpr system("mysql --host=\"<C-r>h\" -u<C-r>u --password=\"<C-r>p\" < ".expand("%:t")) \| silent redraw! \| lopen<CR>

    """ Macros
    let @a = 'ÄkhÄkI-- ÄkdÄkh'
    let @s = 'Äkh3xd$ÄkIselect '"Ä@7;'
endfunction

autocmd FileType sql :call RunMysql()
autocmd FileType python :call RunPython()

nnoremap <C-n> :set rnu!<CR>

set tabstop=4
set shiftwidth=4
set expandtab
