#!/bin/bash

# Versión del script
script_version="1.0.7"
echo "Versión del script: $script_version"

# Directorio base donde se buscarán las carpetas con archivos .ADD
base_dir="/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA"

# Obtener la lista de subdirectorios (carpetas) en base_dir
echo "Selecciona un directorio con archivos .ADD para procesar:"
select dir in $(find "$base_dir" -type d); do
    if [ -n "$dir" ]; then
        echo "Seleccionaste el directorio: $dir"
        break
    else
        echo "Selección no válida, por favor intenta de nuevo."
    fi
done

# Obtener la fecha actual para el nombre del directorio de salida
current_date=$(date +%Y-%m-%d_%H-%M-%S)

# Contar cuántos archivos .ADD (raw data) hay en total
raw_data_files=$(find "$dir" -type f -name "*.ADD" | wc -l)

# Directorio de salida para los archivos MiniSEED, ubicado dentro de base_dir y con el sufijo MiniSEED_$current_date
output_dir="$base_dir/MiniSEED_$current_date"

# Crear el directorio de salida si no existe
mkdir -p "$output_dir"
echo "Directorio de salida creado: $output_dir"

# Crear archivo de log dentro del directorio de salida
log_file="$output_dir/log_digos_to_miniseed_$(date +%Y-%m-%d_%H-%M-%S).log"

# Redirigir la salida estándar y la salida de error al archivo de log
exec > >(tee -a "$log_file") 2>&1

# Contador global para llevar los archivos procesados
total_processed_files=0

# Función para procesar un directorio con porcentaje de progreso
procesar_directorio () {
    local dir=$1
    echo "Procesando archivos de $dir"
    
    # Contar cuántos archivos .ADD hay en total antes de procesarlos
    total_files=$(find "$dir" -type f -name "*.ADD" | wc -l)
    
    # Si no hay archivos .ADD, salimos
    if [ "$total_files" -eq 0 ]; then
        echo "No se encontraron archivos .ADD en $dir"
        return
    fi
    
    echo "Se encontraron $total_files archivos .ADD en $dir."

    # Contador para llevar el progreso
    processed=0

    # Contabilizamos los archivos procesados
    find "$dir" -type f -name "*.ADD" | while read file
    do
        if [ -f "$file" ]; then  # Verificación para asegurarnos que es un archivo
            processed=$((processed + 1))
            percentage=$((processed * 100 / total_files))
            echo "[$percentage%] Convirtiendo $file a MiniSEED..."

            # Ejecutar el comando cube2mseed
            /opt/cubetools-2024.170/bin/cube2mseed --verbose --output-dir="$output_dir" "$file"
            
            # Verificar si la conversión fue exitosa
            if [ $? -eq 0 ]; then
                echo "Archivo $file convertido con éxito."
            else
                echo "Error al convertir $file."
            fi
        fi
    done

    # Aumentamos el contador global de archivos procesados
    total_processed_files=$((total_processed_files + processed))
    echo "Finalizó la conversión de archivos de $dir."
}

# Procesar el directorio base
echo "Iniciando el procesamiento de archivos..."
if [ -d "$dir" ]; then
    procesar_directorio "$dir"
else
    echo "$dir no es un directorio válido."
fi

# Mostrar el total de archivos procesados
echo "Directorio de salida final: $output_dir"
echo "Total de archivos procesados: $total_files."
echo "Procesamiento completado."
