# Pipeline: Airflow + Kafka + Spark

```
API del clima → Airflow → Kafka → Spark
```

## 1. WSL — Instancias nuevas

```powershell
mkdir C:\Users\user\wsl  # Crear carpeta destino [user es tu usuario de sistema]

wsl --export Ubuntu-24.04 C:\Users\user\wsl\ubuntu-base.tar # Exportar Ubuntu actual 

wsl --import UbuntuKafka C:\Users\user\wsl\UbuntuKafka C:\Users\user\wsl\ubuntu-base.tar # Importar con nuevo nombre

wsl --list # Listar instancias

wsl -d UbuntuKafka  # Entrar a la nueva instancia --> Mejor agregarla al terminal

wsl --unregister UbuntuKafka  # Eliminar cuando termines
```


## 2. Entorno virtual Python

```bash
# Crear directorio de trabajo y entramos en el para comenzar con el proyecto de pipeline
mkdir pipeline
cd pipeline

python3 -m venv venv # Crear un entorno en python

source venv/bin/activate  # Activar (siempre antes de trabajar)

deactivate  # Desactivar en caso necesario
```

## 3. Airflow

```bash
# Creo directorio para trabajar con airflow
mkdir airflow
cd airflow

# Variable de entorno 
export AIRFLOW_HOME=$(pwd)
echo $AIRFLOW_HOME  # Para comprobar

# Instalar  y arrancar Airflow
pip install apache-airflow 
airflow standalone # Si levantas sin la variable de entorno problemas al iniciar

# Acceder
http://localhost:8080   # o el puerto que uses

# Contraseña generada (primera vez)
cat $AIRFLOW_HOME/simple_auth_manager_passwords.json.generated

# Resetear BD (regenera contraseña)
airflow db reset
airflow standalone
```

>### Configuracion
- En el archivo `airflow.cfg` tenemos que buscar la variable `load_example` y ponerle el valor **False**
- En el archivo `airflow.cfg` tenemos que buscar la variable `dags_folder` y comprobar que existe ese directorio si no crearlo
- Reiniciar el airflow

## 4. Kafka
Nos vamos a la web oficial para descargarlo: https://kafka.apache.org/ y a continuación nos vamos a Inicio rápido (Quickstart-https://kafka.apache.org/quickstart/)para configurarlo

```bash
# Antes de comenzar con la instalación comprobar versión de Java (requisito), si no esta instalar.
sudo apt update
sudo apt install -y openjdk-17-jdk

# Carpeta de proyecto y descargamos
cd ~/pipeline
wget [url]
```
>### [Quickstart](https://kafka.apache.org/quickstart/)
1. **Obtener Kafka**: En este primer paso, simplemente te encargas de descargar el paquete de archivos desde el sitio oficial y descomprimirlo en tu computadora. 
2. **Iniciar el entorno**: Primero se genera un identificador único para tu grupo de servidores y se prepara el espacio en el disco donde se guardarán los datos; después, inicias el servidor. Una vez que este proceso termina, Kafka queda encendido y "escuchando", esperando a que le envíes información.
3. **Crear un tema (Topic)**: Antes de guardar datos, necesitas crear un contenedor lógico llamado `Topic`. Imaginalo como una carpeta o un canal de chat específico donde se organizará la información (por ejemplo, uno para "pagos" y otro para "ubicaciones GPS"). En este paso, le das una instrucción al servidor para que reserve ese nombre y prepare la estructura donde se almacenarán tus mensajes.
4. **Escribir eventos** En esta etapa actúas como un `Productor`. Utilizas una herramienta de envío para escribir mensajes de texto y mandarlos al servidor; cada línea que escribes y envías se convierte en un "evento" que Kafka recibe y guarda de forma segura. El servidor se asegura de que esos datos no se pierdan y estén disponibles para quien los necesite más adelante.
5. **Leer los eventos**: Finalmente, actúas como un `Consumidor`. Abres una ventana nueva para leer los mensajes que guardaste anteriormente; lo interesante es que puedes ver los mensajes viejos y también recibir en tiempo real los nuevos que vayas escribiendo. Como Kafka almacena los datos de forma permanente, podrías cerrar esta ventana y volver a leer todo desde el principio tantas veces como quieras sin que los datos se borren.


## 5. Spark
Nos vamos a la web oficial para descargarlo: https://spark.apache.org/ 

```bash
# Carpeta de proyecto y descargamos
cd ~/pipeline
wget [url]
```

>### Configuracion
- Una vez descomprimido nos vamos a la carpeta `conf` y el archivo de spark-default lo renombramos quitando el template, para abrirlo y reeditarlo. Añadiendo las siguientes lineas:
  - spark.master.port 7077
  - spark.master.ui.port 9090 

>### Despliegue
Vamos a la siguiente web y seguimos los pasos [Spark Standalone Mode](https://spark.apache.org/docs/latest/spark-standalone.html)
Donde además de del master arrancaremos un workers y comprobaremos que esta activo.

## Creación del DAG
Vamos a la siguiente web [Dags](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html)

![img dag](/web/img/img-dag.png)

>### Plantilla mínima para DAG de Airflow ###

```bash

# Importaciones mínimas (solo lo esencial)
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator

# PASO 1: DEFINIR EL DAG (el grafo)
# ========================================
dag = DAG(
    dag_id='MI_PRIMER_DAG',           # NOMBRE ÚNICO DEL GRAFO
    start_date=datetime(2026, 3, 24),  # FECHA DE INICIO (cualquier día pasado)
    schedule_interval='@hourly',       # CUÁNDO EJECUTAR: @hourly, @daily, '0 2 * * *' (cron)
    catchup=False,                     # NO EJECUTAR PASADOS
    tags=['aprendizaje'],              # ETIQUETAS PARA BUSCAR EN UI
)

# PASO 2: FUNCIÓN PARA PRIMERA TAREA
# ========================================
def tarea_uno():
    """Función que hace algo simple (task 1)"""
    print("¡Hola desde la primera tarea!")
    resultado = "datos de tarea 1"
    return resultado  # Airflow lo guarda automáticamente en XCom

# PASO 3: FUNCIÓN PARA SEGUNDA TAREA
# ========================================
def tarea_dos(**context):
    """Función que recibe datos de la primera tarea (task 2)"""
    # RECOGER DATOS DE LA TAREA ANTERIOR
    datos_anteriores = context['ti'].xcom_pull(task_ids='tarea_simple_1')
    print(f"Recibí: {datos_anteriores}")
    print("¡Segunda tarea terminada!")

# PASO 4: CREAR LAS TAREAS (nodos del grafo)
# ========================================
task1 = PythonOperator(
    task_id='tarea_simple_1',    # ID ÚNICO (sin espacios)
    python_callable=tarea_uno,   # FUNCIÓN QUE EJECUTA
    dag=dag                     # PERTENECE A ESTE DAG
)

task2 = PythonOperator(
    task_id='tarea_simple_2',
    python_callable=tarea_dos,
    dag=dag
)

# PASO 5: DEFINIR DEPENDENCIAS (flechas del grafo)
# ========================================
task1 >> task2  # task1 PRIMERO, luego task2

```