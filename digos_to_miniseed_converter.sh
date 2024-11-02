#!/bin/bash

# Directorios base donde están los archivos ADD
base_dir_1="/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/Datos_cedia_infra_nasa"
base_dir_2="/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/Datos_cedia_infra_nasa_2"

# Directorio de salida para los archivos MiniSEED
output_dir="/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/MiniSEED"

# Crear el directorio de salida si no existe
mkdir -p "$output_dir"

# Función para procesar un directorio con porcentaje de progreso
procesar_directorio () {
    local dir=$1
    echo "Procesando archivos en $dir"
    
    # Contar cuántos archivos hay en total
    total_files=$(ls "$dir"/*.ADD 2>/dev/null | wc -l)
    
    # Si no hay archivos .ADD, salimos
    if [ "$total_files" -eq 0 ]; then
        echo "No se encontraron archivos .ADD en $dir"
        return
    fi
    
    # Contador para llevar el progreso
    processed=0

    for file in "$dir"/*.ADD
    do
        if [ -f "$file" ]; then
            processed=$((processed + 1))
            percentage=$((processed * 100 / total_files))
            echo "[$percentage%] Convirtiendo $file a MiniSEED..."
            /opt/cubetools-2024.170/bin/cube2mseed --verbose --output-dir="$output_dir" "$file"
        fi
    done
}

# Procesar las carpetas base y sus subdirectorios
for dir in "$base_dir_1"/* "$base_dir_2"/*
do
    if [ -d "$dir" ]; then
        procesar_directorio "$dir"
    fi
done
