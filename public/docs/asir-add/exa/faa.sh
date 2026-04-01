#!/bin/bash

#FUNCION BUSCAR
function buscar () {
   archivo=$1
   busqueda=$(find -name $archivo)
   echo "$busqueda"
   if (( "$busqueda" == "$archivo" )); then
      echo "$archivo"
   fi
}

#FUNCION CREAR
function crear () {
   archivo=$1
   tamanyo=$2
   echo "$tamanyo"
   if (( $tamanyo )); then
      truncate -s "${tamanyo}${K}" "$archivo"
   else
      truncate -s "1024K" "$archivo"
   fi
}

#FUNCION AUTOMATIZAR
function automatizar () {
      for usuario in $(find /mnt/usuarios/* | cut -d / -f 4); do
         usuarios=${usuarios+1}
         sudo useradd "$usuario"
         sudo mkdir /home/$usuario
      done
}

#FUNCION LISTA
function lista () {
   archivo=$1
   archivoExiste=$(find $archivo)
   if (( $archivo == $archivoExiste )); then {
      echo "El archivo de lista existe, escribiendo sobre el mismo..."
      read -p "Introduce un nuevo elemento (ENTER para Salir)" elemento
      while [[ $elemento ]]; do
        busqueda=$(grep "$elemento" "$archivo")
        if (( $busqueda )); then {
           echo "El elemento ya existe."
           continue
        }
        else {
           cat "$elemento" >> $archivo
        }
        fi
        read -p "Introduce otro elemento (ENTER para Salir)" elemento
      done
   }
   fi
}

#FUNCION SAMBA
#function samba () {
#}

#PROGRAMA PRINCIPAL
op=6
while (( op != 0 )); do
   #MENU CON LAS OPCIONES DISPONIBLES
   echo "****************"
   echo "      MENU      "
   echo "****************"
   echo "1. Buscar"
   echo "2. Crear"
   echo "3. Automatizar"
   echo "4. Lista"
   echo "5. Samba"
   echo "0. Salir"
   echo ""
   #RECOGIDA DE INPUT DEL USUARIO
   read	-p "Introduce una opción del menu (1-5): " op
   #OPCION 1 (BUSCAR)
   if (( op == 1 )); then {
      read -p "Introduce el nombre del archivo a buscar: " archivo
      buscar "$archivo"
   }
   #OPCION 2 (CREAR)
   elif (( op == 2 )); then
      read -p "Introduce el nombre del archivo: " nombre
      read -p "Introduce el tamaño del archivo: " tamanyo
      crear "$nombre" "$tamanyo"
   #OPCION 3 (AUTOMATIZAR)
   elif (( op == 3 )); then
      automatizar
   #OPCION 4 (LISTA)
   elif (( op == 4 )); then
      read -p "Introduce el nombre del archivo de lista: " lista
      lista $lista
   #OPCION 5 (SAMBA)
   elif (( op == 5 )); then
      echo "5"
   #OPCION 0 (SALIDA)
   elif (( op == 0 )); then
      echo "Has salido del programa"
   #OPCION INVALIDA
   else
      echo "Opción inválida"
   fi
done
