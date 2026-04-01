
# Visual Studio Code usando WSL y Docker

- [Visual Studio Code usando WSL y Docker](#visual-studio-code-usando-wsl-y-docker)
  - [Extensiones necesarias en Visual Studio Code para trabajar con Docker y WSL](#extensiones-necesarias-en-visual-studio-code-para-trabajar-con-docker-y-wsl)
- [1. Ejecutar Visual Studio Code en Ubuntu (WSL)](#1-ejecutar-visual-studio-code-en-ubuntu-wsl)
  - [1.1 Abrir Ubuntu (WSL)](#11-abrir-ubuntu-wsl)
  - [1.2 Ir al directorio de trabajo](#12-ir-al-directorio-de-trabajo)
  - [1.3 Abrir Visual Studio Code desde Ubuntu](#13-abrir-visual-studio-code-desde-ubuntu)
  - [1.4 Comprobar que Docker funciona](#14-comprobar-que-docker-funciona)
- [2. Uso de contenedores Docker desde Visual Studio Code](#2-uso-de-contenedores-docker-desde-visual-studio-code)
  - [2.1 Crear un proyecto Python](#21-crear-un-proyecto-python)
  - [2.2 Crear un script Python](#22-crear-un-script-python)
  - [2.3 Crear un Dockerfile](#23-crear-un-dockerfile)
  - [2.4 Construir la imagen](#24-construir-la-imagen)
  - [2.5 Ejecutar el contenedor](#25-ejecutar-el-contenedor)
- [Resumen](#resumen)

Una vez instalado **WSL**, configurado **Ubuntu** y teniendo **Docker Desktop** integrado con **Visual Studio Code**, el siguiente paso es trabajar directamente desde el entorno Linux y comenzar a ejecutar contenedores.

Este documento describe cómo utilizar Visual Studio Code dentro de Ubuntu y cómo crear y ejecutar un contenedor sencillo con Python, que servirá como base para proyectos más complejos.

## Extensiones necesarias en Visual Studio Code para trabajar con Docker y WSL
Instalar [Visual Studio Code](https://code.visualstudio.com/). Se recomienda instalar las siguientes extensiones:
- Python
- Jupyter
- WSL (si usáis WSL2)
- GitHub Copilot

- **Remote - WSL**  
Permite abrir y trabajar en el entorno Linux (Ubuntu) desde Visual Studio Code utilizando WSL.

- **Docker**  
Permite crear, ejecutar y gestionar contenedores e imágenes Docker directamente desde Visual Studio Code.

- **Python**  
Proporciona soporte para desarrollar, ejecutar y depurar scripts Python dentro del editor.

- **Dev Containers**  
Permite abrir proyectos directamente dentro de contenedores Docker para trabajar en entornos aislados y reproducibles.

- **YAML**  
Facilita la edición y validación de archivos de configuración como `docker-compose.yml`.

- **GitHub Pull Requests and Issues**  
Permite gestionar repositorios, cambios y revisiones de código desde Visual Studio Code.

- **Markdown All in One**  
Mejora la edición de archivos Markdown con herramientas de formato, tablas y atajos de escritura.

# 1. Ejecutar Visual Studio Code en Ubuntu (WSL)

Trabajar desde Ubuntu dentro de WSL permite utilizar herramientas Linux
reales, gestionar dependencias de forma más sencilla y ejecutar
contenedores Docker en un entorno similar a producción.

## 1.1 Abrir Ubuntu (WSL)

``` bash
wsl
```

o bien:

``` bash
ubuntu
```

------------------------------------------------------------------------

## 1.2 Ir al directorio de trabajo

``` bash
cd ~
mkdir proyectos
cd proyectos
```

------------------------------------------------------------------------

## 1.3 Abrir Visual Studio Code desde Ubuntu

``` bash
code .
```

Esto:

-   Abre Visual Studio Code
-   Conecta automáticamente con WSL
-   Permite trabajar como si estuvieras en Linux real

------------------------------------------------------------------------

## 1.4 Comprobar que Docker funciona

``` bash
docker --version
docker run hello-world
```

------------------------------------------------------------------------

# 2. Uso de contenedores Docker desde Visual Studio Code

Los contenedores permiten ejecutar aplicaciones en entornos aislados,
reproducibles y portables.

------------------------------------------------------------------------

## 2.1 Crear un proyecto Python

``` bash
mkdir python-docker
cd python-docker
```

------------------------------------------------------------------------

## 2.2 Crear un script Python

Archivo:

``` bash
nano app.py
```

Contenido:

``` python
print("Hola desde un contenedor Docker con Python")
```

------------------------------------------------------------------------

## 2.3 Crear un Dockerfile

Archivo:

``` bash
nano Dockerfile
```

Contenido:

``` dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY app.py .

CMD ["python", "app.py"]
```

------------------------------------------------------------------------

## 2.4 Construir la imagen

``` bash
docker build -t mi-python .
```

------------------------------------------------------------------------

## 2.5 Ejecutar el contenedor

``` bash
docker run mi-python
```

Salida esperada:

    Hola desde un contenedor Docker con Python

------------------------------------------------------------------------

# Resumen

Se ha aprendido a:

-   Ejecutar VS Code en Ubuntu
-   Crear un script Python
-   Crear un Dockerfile
-   Construir una imagen
-   Ejecutar un contenedor
