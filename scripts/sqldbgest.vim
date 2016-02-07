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
" set cpo&vim

let w:valores = ['','','','','']
function! MenuPrincipal()
    let a:guardacursor = getcurpos()
    let s:salir = 0
    let s:default = 1
    while s:salir == 0
        let s:accion=confirm("", "&1 Configurar conexión\n&2 Ver datos\n&3 Test de conexión\n&4 Salir", s:default)
        if s:accion == 1
            call s:Datos()
        elseif s:accion == 2
            call s:Verdatos()
        elseif s:accion == 3
            call s:PruebaConexion()
        elseif s:accion == 4
            let s:salir = 1
        endif
        let s:default = 4
    endwhile
    call setpos('.', a:guardacursor)
endfunction

function! s:Pedir(arg)
    let a:preguntas = ['Host IP: ', 'Nombre de la Base de datos: ', 'Usuario: ', 'Contraseña: ']
    if a:arg < 3
        return input(a:preguntas[a:arg])
    elseif a:arg == 3
        return inputsecret(a:preguntas[a:arg])
    elseif a:arg == 4
        return confirm('Sistema Gestor: ', "&1. MySql\n&2. PostgresSQL\n&3. Oracle 11g", 1)
    endif
endfunction

function! s:Datos()
    let a:modificacion = inputlist(['1. Todos', '2. Host IP', '3. Nombre de BDD', '4. Usuario', '5. Contraseña', '6. Sistema Gestor', '7. Salir y guardar', '8. Salir SIN guardar'])
    if a:modificacion == 1
        for item in [0,1,2,3,4]
            let w:valores[item] = s:Pedir(item)
        endfor
        call s:GrabarDatos()
    elseif a:modificacion > 1 && a:modificacion < 7 
        let w:valores[a:modificacion - 2] = s:Pedir(a:modificacion - 2)
        call s:GrabarDatos()
    endif
    call s:ActivarComandos()
endfunction

function! s:Verdatos()
    echo "Host IP: " . w:valores[0]
    if w:valores[4] == 1 || w:valores[4] == 2
        echo "Base de datos: " . w:valores[1]
    endif
    echo "Usuario: " . w:valores[2]
    if w:valores[4] == 1
        let a:sistema = 'MySql'
    elseif w:valores[4] == 2
        let a:sistema = 'PostgreSql'
    elseif w:valores[4] == 3
        let a:sistema = 'Oracle 11g'
    endif
    echo "Sistema: " . a:sistema
    call s:GrabarDatos()
endfunction

" function! Mysql(opcion)
"    if a:opcion == 1
"        execute "!mysql -h" . w:valores[0] . " -u" . w:valores[2] . " -p" . w:valores[3] . " -D" . w.valores[1]
"    endif
" endfunction

function! s:CargarValores()
    call s:LineasDatos()
    let a:lineas = getline(s:rango[0],s:rango[1])
    for linea in a:lineas
        if match(linea, 'SG:') == 0
            let a:sg = strpart(linea, 4)
            if tolower(a:sg) == 'mysql'
                let w:valores[4] = 1
            elseif tolower(a:sg) == 'postgressql'
                let w:valores[4] = 2
            elseif tolower(a:sg) == 'oracle 11g'
                let w:valores[4] = 3
            endif
        elseif match(linea, 'Host IP:') == 0
            let w:valores[0] = strpart(linea,9)
        elseif match(linea, 'Base de datos:') == 0
            let w:valores[1] = strpart(linea, 15)
        elseif match(linea, 'Usuario:') == 0
            let w:valores[2] = strpart(linea, 9)
        elseif match(linea, 'Contraseña: ') == 0
            let w:valores[3] = strpart(linea, 13)
        endif
    endfor
endfunction

function! s:LineasDatos()
    let s:rango = [0,0]
    let s:rango[0] = search('<<Inicio sqldbgest>>')
    let s:rango[1] = search('<<Fin sqldbgest>>')
endfunction

function! s:GrabarDatos()
    if confirm('¿Grabar datos en el fichero?', "&S Sí\n&N No") == 1
        call s:LineasDatos()
        if s:rango[0] == 0
            let a:fallo = append(0, '/* ATENCIÓN: No modificar estas líneas manualmente')
            let a:fallo = append(1, '<<Inicio sqldbgest>>')
            let a:fallo = append(2, 'Host IP: ' . w:valores[0])
            let a:fallo = append(3, 'Base de datos: ' . w:valores[1])
            let a:fallo = append(4, 'Usuario: ' . w:valores[2])
            let a:fallo = append(5, 'Contraseña: ' . w:valores[3])
            if w:valores[4] == 1
                let a:sg = 'MySql'
            elseif w:valores[4] == 2
                let a:sg = 'PostgresSQL'
            else 
                let a:sg = 'Oracle 11g'
            endif
            let a:fallo = append(6, 'SG: ' . a:sg)
            let a:fallo = append(7, '<<Fin sqldbgest>>')
            let a:fallo = append(8, 'ATENCIÓN: No modificar estas líneas manualmente */')
        else 
            call setline(s:rango[0] + 1, ['Host IP: ' . w:valores[0], 'Base de datos: ' . w:valores[1], 'Usuario: ' . w:valores[2], 'Contraseña: ' . w:valores[3]])
            if w:valores[4] == 1
                let a:sg = 'MySql'
            elseif w:valores[4] == 2
                let a:sg = 'PostgresSQL'
            else 
                let a:sg = 'Oracle 11g'
            endif
            call setline(s:rango[0] + 5, 'SG: ' . a:sg)
        endif
    endif
endfunction

function! s:ActivarComandos()
    if w:valores[4] == 1
        nnoremap <F6> :w! <bar> :!mysql --host="<C-r>h" -u<C-r>u --password="<C-r>p" -D<C-r>d < '%:t'<CR>
        "nnoremap <C-F6> "eyy <bar> :!mysql --host=<C-r>h -u<C-r>u -p<C-r>p -D<C-r>d --execute="<C-r>e"<CR>
        nnoremap <C-F6> "eyy <bar> :call Mysql(1)<CR>
        nnoremap <F7> :w! <bar> :lexpr system("mysql --host=\"<C-r>h\" -u<C-r>u --password=\"<C-r>p\" -D<C-r>d < ".expand("%:t")) \| silent redraw! \| lopen<CR>
        nnoremap <C-F7> "eyy <bar> :lexpr system("mysql --host=<C-r>h -u<C-r>u --password=<C-r>p --database=<C-r>d --execute=\"<C-r>e\"") \| silent redraw! \| lopen<CR>
        nnoremap <C-F6> "eyy <bar> :!mysql --host=<C-r>h -u<C-r>u -p<C-r>p -D<C-r>d --execute="<C-r>e"<CR>
    elseif w:valores[4] == 2
        nnoremap <F6> :w! <bar> :execute "!export PGPASSWORD=" . w:valores[3] . "; psql -d" . w:valores[1] ." -h" . w:valores[0] . " -U" . w:valores[2] ." -f " . "%:t"<CR>
        nnoremap <F7> :w! <bar> :lexpr system("export PGPASSWORD=" . w:valores[3] . "; psql -h" . w:valores[0] . " -U" . w:valores[2] . " -d" . w:valores[1] . " -f ".expand("%:t")) \| silent redraw! \| lopen<CR>
        nnoremap <F8> :let comando = getline(line('.')) <bar> :execute "!export PGPASSWORD=" . w:valores[3] . " ; psql -h" . w:valores[0] . " -U" . w:valores[2] . " -d" . w:valores[1] . " -c\"" . comando . "\""<CR>
"        nnoremap <F9> :let comando = getline(line('.')) <bar> :lexpr system("export PGPASSWORD=" . w:valores[3] . "; psql -h" . w:valores[0] . " -U" . w:valores[2] . " -d" . w:valores[1] . " -c \"" . comando . "\"")) \| silent redraw! \| lopen<CR>
"        nnoremap <F9> "eyy <bar> :lexpr system("psql -h<C-r>h -U<C-r>u -d<C-r>d -c \"<C-r>e\"") \| silent redraw! \| lopen<CR>
    endif
endfunction


if search('<<Inicio sqldbgest>>') != 0
    call s:CargarValores()
    call s:ActivarComandos()
    call setpos('.',[0,s:rango[1]+2,1,1])
endif

" nnoremap <S-F3> :execute "!ls " . w:comando<CR>
nnoremap <F2> :call MenuPrincipal()<CR>
" Restauración del modo compatible
" let &cpo = s:save_cpO
