#!/bin/bash
function buscar() {
	read -p "dime un fichero que se buscara por el sistema" f
	bus=$( sudo find / -type f -name $f | head -n 1 2>/dev/null )
	if [ -z $bus ]; then
		echo "Error el archivo no existe"
	else
		counta=$( grep -o -i "a" $bus | wc -l )
		counte=$( grep -o -i "e" $bus | wc -l)
		counti=$( grep -o -i "i" $bus | wc -l)
		counto=$( grep -o -i "o" $bus | wc -l)
                countu=$( grep -o -i "u" $bus | wc -l)
                countas=$( grep -o -i "á" $bus | wc -l)
                countes=$( grep -o -i "é" $bus | wc -l)
                countis=$( grep -o -i "í" $bus | wc -l)
                countos=$( grep -o -i "ó" $bus | wc -l)
                countus=$( grep -o -i "ú" $bus | wc -l)
		count=$((counta + counte + counti + counto + countu + countas + countes  + countis  + countos + countus))
		echo "El archivo esta en $bus"
		echo "El archivo tiene $count vocales"
	fi
}
function crear() {
	fic=$1
	ta=$2
	if [[ ! -z $fic && ! -z $ta ]]; then
		truncate -s "$ta"K "$fic"
	elif [[ ! -z $fic && -z $ta ]]; then
		ta=1024
		truncate -s 1024K "$fic"
	elif [[ -z $fic && ! -z $ta ]]; then
		fic="fichero_vacio"
		truncate -s "$ta"K fichero_vacio
	else
		ta=1024
		fic="fichero_vacio"
		truncate -s 1024K fichero_vacio
	fi
	echo "Se ha creado el fichero $fic con $ta Kilobytes"
}
function automatizar() {
	com=$(sudo ls /mnt/usuarios 2>/dev/null)
	if [ -z $com ]; then
		echo "LISTADO VACIO"
	else
		for lista in $com; do
			if [ -f /mnt/usuarios/$lista ]; then
				sudo useradd -m "$lista"
				dir=$(cat /mnt/usuarios/$lista)
				for direc in $dir; do
					sudo mkdir /home/$lista/$direc
				done
				sudo rm /mnt/usuarios/$lista
				echo "Se ha creado el usuario $lista con sus directorios"
			fi
		done
	fi
}
function lista() {
	read -p "Dime el nombre que quieres que tenga la lista de la compra" lista
	read -p "¿Que alimento quieres añadir a la lista?" ali
	touch $lista
	exist=$(grep -i -o "$ali" $lista)
	if [ -z $lista ]; then
		cat $lista << EOF
$ali
EOF
		echo "Se ha añadifo el alimiento $ali"
	else
		echo "El elemento ya existe"
	fi
}
function menu() {
	op=1
	while [ $op -ne 0 ]; do
		echo "====MENU===="
		echo "0.Salir"
		echo "1. buscar"
		echo "2. Crear"
		echo "3. automatizar"
		echo "4. lista"
		echo "==========="
		read -p "Escoge una opcion" op
		case $op in
			0)
			echo "Has Salido del script"
			;;
			1)
			buscar
			;;
			2)
			read -p "Dime nombre de fichero que quieras crear" fic
			read -p "Dime el tamaño que quieres que sea ese fichero en kilobytes" ta
			crear $fic $ta
			;;
			3)
			automatizar
			;;
			4)
			lista
			;;
			*)
			echo "OPCION NO VALIDA"
			;;
		esac
	done
}
menu

