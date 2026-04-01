function buscar (

    echo "No realizado"

)

function crear (

    local nom=$1
    local tam=$2

    if [ -z $nom ];then
        nom="fichero_vacio"
    fi

    if [ -z $tam ];then
        tam=1024
    fi

    if [ $# == 1 ];then
        if [ $1 in [^*1-9] ];then
            $nom = "fichero_vacio"
            $tam = $1
        else
            $nom = $1
            $tam = 1024
        fi
    fi

    echo "Se creara el fichero $nom de tamaño $tam KB."
    #dd /dev/null $nom $tam
    #echo "Fichero creado."

)

function automatizar (

    echo "No realizado"

)

function lista (

    read -p "Introduce el nombre del fichero: " nomlista

    if [ -f $nomlista ];then
        read -p "Escribe el elemento a intoroducir a la lista: " elem
        vacio=cat $nomlista | grep "$elem"
        if [ -z $vacio ];then
            echo "$elem" > $nomlista
        fi
    else
        sudo touch $nomlista
        vacio=cat $nomlista | grep "$elem"
        if [ -z $vacio ];then
            echo "$elem" > $nomlista
        fi
    fi

)

function samba (

    echo "No realizado"

)


op=1
while [ $op -ne 0 ];do

    echo "1. Buscar fichero"
    echo "2. Crear fichero"
    echo "3. Automatizar creacion de usuarios"
    echo "4. Lista de la compra"
    echo "5. Samba"
    echo "0. Salir"

    read -p "Selecciona que deseas ejecutar:" op

    case $op in
        1)buscar;;
        2)
          read -p "Selecciona el nombre del archivo: " nomarch
          read -p "Selecciona el tamaño: " tamarch
          crear "$nomarch" "$tamarch";;
        3)automatizar;;
        4)lista;;
        5)samba;;
        0)
          break;;
        *)
          echo "Opcion no valida";;
    esac
    read -p "Pulsa ENTER para continuar..."
    clear
done
