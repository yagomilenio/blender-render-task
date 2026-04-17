# Blender Parallel Render Task

Este repositorio proporciona una tarea distribuible para renderizar animaciones de Blender en paralelo. Está diseñado para ejecutarse en una plataforma de paralelización donde múltiples workers pueden renderizar distintos segmentos (chunks) de una animación de forma simultánea.
## Cómo Funciona
La tarea se integra con una plataforma de paralelización que lee la configuración, divide el trabajo y lo distribuye entre los workers. Cada worker ejecuta el script `render.sh` para renderizar su rango de frames asignado.
```
Plataforma de Paralelización
  │
  ├── Lee config.toml
  │
  └── Lanza en cada worker:
        bash render.sh --start 1   --end 25   --output outputs/frames_1_25.tar.gz
        bash render.sh --start 26  --end 50   --output outputs/frames_26_50.tar.gz
        ...
```
## Estructura del Repositorio
```
.
├── config.toml       # Define los requisitos, entradas y rango de frames para la plataforma.
├── Makefile          # Comandos para configuración local y pruebas manuales.
├── render.sh         # Script que renderiza un chunk de frames usando la CLI de Blender.
├── obtain_frames.sh  # Script de utilidad para inspeccionar el rango de frames de un archivo .blend.
└── outputs/          # (Generado) Directorio para los archivos comprimidos de frames renderizados.
    ├── frames_1_25.tar.gz
    └── frames_26_50.tar.gz
```
*Nota: La aplicación Blender y los archivos de escena `.blend` se descargan en tiempo de ejecución según lo definido en `config.toml`.*
## Configuración (`config.toml`)
Este archivo es el punto de entrada principal para la plataforma de paralelización.
-   `[requirements]`: Especifica los paquetes de sistema necesarios.
-   `[[download.files]]`: Lista los archivos a descargar antes de la ejecución, como la aplicación Blender y el archivo de escena `.blend`.
-   `[inputs.range_continuous]`: Define el rango total de frames de la animación. La plataforma dividirá automáticamente este rango entre los workers disponibles.
-   `[outputs]`: Especifica el directorio de salida y el patrón de nombres para los archivos resultantes.
Para cambiar el rango de frames de la animación, edita el valor `end`:
```toml
[inputs.range_continuous]
start = 1
end   = 250   # ← Ajusta para que coincida con el total de frames de tu escena
step  = 1
```
## Script del Worker (`render.sh`)
Es el script principal ejecutado por cada worker. Realiza las siguientes acciones:
1.  Acepta los argumentos `--start` y `--end` para definir el rango de frames del chunk actual.
2.  Detecta la mejor GPU disponible para renderizar (`CUDA`, `HIP`, `OPENCL`), usando `CPU` como fallback si no se encuentra ninguna.
3.  Invoca la interfaz de línea de comandos de Blender para renderizar los frames especificados.
4.  Empaqueta las imágenes PNG resultantes en un archivo comprimido (`.tar.gz`).
## Uso Manual
El `Makefile` proporciona comandos de ayuda para la configuración local y las pruebas. Estos comandos asumen que los archivos necesarios (como el archivo de Blender) han sido descargados.
1.  **Configurar Blender**
    Descomprime el archivo de Blender y lo deja listo para usar.
    ```bash
    make setup
    ```
2.  **Ejecutar un Job de Renderizado**
    Renderiza un rango específico de frames. Debes proporcionar los valores `START` y `END`.
    ```bash
    # Renderiza los frames del 1 al 50
    make run START=1 END=50
    ```
3.  **Ejecutar una Prueba Rápida**
    Renderiza una muestra pequeña (frames 1-3) para verificar la configuración.
    ```bash
    make test
    ```
4.  **Limpiar Salidas**
    Elimina el directorio `outputs/` y todo su contenido.
    ```bash
    make clean
    ```
## Script de Utilidad (`obtain_frames.sh`)
Puedes usar este script para averiguar rápidamente los frames de inicio y fin de tu animación directamente desde el archivo `.blend`. Es útil para configurar correctamente el valor `end` en `config.toml`.
```bash
bash obtain_frames.sh
# Salida esperada:
# Frames: 1 - 250
```
