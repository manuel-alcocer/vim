" Vim 'filetype plugin' para trabajar con algunos sistemas gestores
" de bases de datos en SQL.
" Script Name: sqldbgest.vim
" Last Change: Today
" Maintaner: Manuel Alcocer <m.alcocer1978@gmail.com>
" License: GPL 2

"" Inicialización del script
if exists("g:sqldbgest_cargado")
    finish
endif
let g:sqldbgest_cargado = 0
let s:save_cpo = &cpo
set cpo&vim

let s:insertados = 0

function! MenuPrincipal()
    let s:salir = 0
    let s:default = 1
    while s:salir == 0
        let s:accion=confirm("Opciones:", "&1 Datos conexion\n&2 Ver datos\n&3 Test de conexión\n&4 Salir", s:default)
        if s:accion == 1
            call s:Datos()
        elseif s:accion == 2
            call s:Verdatos()
        elseif s:accion == 3
            call s:Prueba()
        elseif s:accion == 4
            let s:salir = 1
        endif
        let s:default = 4
    endwhile
endfunction

function! s:Datos()
    let @h = input("IP del equipo: ")
    let @g = confirm("\nElige sistema gestor:", "&1 Oracle\n&2. PostgreSql\n&3. Mysql", 3)
    let @d = input('Nombre de la base de datos: ')
    let @u = input('Usuario: ')
    let @p = inputsecret("Introduce el password: ")
    let @x = "<<configurado>>"
    call s:ActivarComandos()
endfunction

function! s:Verdatos()
    echo "HOST: " . @h 
    if @g == 1
        let s:sistema = 'Oracle 11g'
    elseif @g == 2
        let s:sistema = 'PostgreSql'
    elseif @g == 3
        let s:sistema = 'Mysql'
    endif
    echo "Sistema: " . s:sistema
    if @g == 2 || @g == 3
        echo "Base de datos " . @d
    endif
    echo "Usuario: " . @u
    let s:verpass = confirm('Ver password: ' ,"&S Sí\n&N No")
    if s:verpass == 1
        echo "password: " . @p 
    endif
endfunction

function! s:ActivarComandos()
    if @g == 3
        nnoremap <F6> "eyy <bar> :!mysql --host=<C-r>h -u<C-r>u -p<C-r>p -D<C-r>d --execute="<C-r>e"<CR>
        nnoremap <F7> "eyy <bar> :lexpr system("mysql --host=<C-r>h -u<C-r>u --password=<C-r>p --database=<C-r>d --execute=\"<C-r>e\"") \| silent redraw! \| lopen<CR>
        nnoremap <F8> :w! <bar> :!mysql --host="<C-r>h" -u<C-r>u --password="<C-r>p" -D<C-r>d < '%:t'<CR>
        nnoremap <F9> :w! <bar> :lexpr system("mysql --host=\"<C-r>h\" -u<C-r>u --password=\"<C-r>p\" -D<C-r>d < ".expand("%:t")) \| silent redraw! \| lopen<CR>
    elseif @g == 2
        nnoremap <F6> :w! <bar> :!psql -d<C-r>d -h<C-r>h -U<C-r>u -f "%:t"<CR>
        nnoremap <F7> "eyy <bar> :!psql -d<C-r>d -h<C-r>h -U<C-r>u -c "<C-r>e"<CR>
        nnoremap <F8> :w! <bar> :lexpr system("psql -h\"<C-r>h\" -U<C-r>u -d<C-r>d -f ".expand("%:t")) \| silent redraw! \| lopen<CR>
        nnoremap <F9> "eyy <bar> :lexpr system("psql -h<C-r>h -U<C-r>u -d<C-r>d -c \"<C-r>e\"") \| silent redraw! \| lopen<CR>
    elseif @g == 1
        finish
    endif
endfunction

if @x == '<<configurado>>'
    call s:ActivarComandos()
endif 

nnoremap <F2> :call MenuPrincipal()<CR>
" Restauración del modo compatible
let &cpo = s:save_cpo
