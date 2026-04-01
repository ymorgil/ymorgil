#!/bin/bash

buscar(){
	echo ""
	read -p "Que fichero desea buscar en el sistema?: " fichero

	comprobacion=$(find / -type f -name "$fichero" 2> /dev/null)

	if [ -z $comprobacion ]; then
		echo ""
		echo "ERROR: EL fichero $fichero no se ha encontrado."
	else
		echo ""
		echo "El fichero se encuentra en $(dirname $comprobacion) y tiene $(grep -Eoi 'a|e|i|o|u' $comprobacion 2> /dev/null | wc -l 2> /dev/null) vocales."
	fi
}

crear(){
	nombre=$1
	tamanio=$2

	if [[ ! -z $nombre && ! -z $tamanio ]]; then
		truncate -s "$tamanio"KB "$nombre"
		echo ""
		echo "Archivo $nombre creado con $tamanio KB"

	elif [[ ! -z $nombre && -z $tamanio ]]; then
		truncate -s "1024"KB "$nombre"
		echo ""
		echo "Archivo $nombre creado con 1024 KB"

	else
		truncate -s "1024"KB "fichero_vacio"
		echo ""
		echo "Archivo fichero_vacio con 1024 KB"
	fi
}

automatizar(){
	comprobacion=$(sudo find /mnt/usuarios/ -type f 2> /dev/null)

	if [ -z $comprobacion ]; then
		echo ""
		echo "El directorio está vacio."
	else
		for archivo in $comprobacion; do
			usuario=$(basename $archivo)
			sudo useradd -m "$usuario"

			contenido=$(cat $archivo)
			for carpetas in $contenido; do
				sudo mkdir /home/"$usuario"/"$carpetas"
			done

			sudo rm $archivo
		done
	fi
	echo ""
	echo "Proceso completado."
}

lista(){
	echo ""
	read -p "Introduzca el nombre de la lista de la compra: " lista

	comprobacion=$(find / -type f -name "$lista" 2> /dev/null)

	if [ -z $comprobacion ]; then
		touch "$lista"
		nueva_lista="$lista"
	fi
}

opcion=8
while [[ $opcion -ne 0 ]]; do

	echo ""
	echo "===== MENU DE OPCIONES ====="
	echo ""
	echo "1. Buscar"
	echo "2. Crear"
	echo "3. Automatizar"
	echo "4. Lista"
	echo "5. Samba"
	echo "0. Salir"
	echo ""
	read -p "Seleccione una de las siguientes opciones: " opcion

	case $opcion in

		1) buscar;;

		2)
			echo ""
			read -p "Que nombre le quiere poner al archivo?: " nombre
			read -p "Tamaño en KB?: " tamanio
			crear $nombre $tamanio
		;;
		3) automatizar;;

		4) lista;;

		5);;

		0) echo "Saliendo...";;

		*) echo "Opción erronea, eliga de nuevo."

	esac
done
