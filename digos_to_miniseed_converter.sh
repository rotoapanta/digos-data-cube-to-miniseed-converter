#!/bin/bash

# Script Name: digos_to_miniseed_converter.sh
# Description: Converts ADD (raw data) files to MiniSEED format.
# Version: 1.4.0
# Author: Roberto Toapanta
# Date: 2024-09-18
# License: GNU General Public License v3.0

# Script version
script_version="1.4.0"
echo "Script version: $script_version"

# Base directory where directories with .ADD files are located.
base_dir="/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/"

# Global variable to track the total number of processed files.
total_files_processed=0

# Prompt the user to select a directory.
echo "Select a directory with .ADD files to process:"
select dir in $(find "$base_dir" -type d); do
    if [ -n "$dir" ]; then
        echo "You selected the directory: $dir"
        break
    else
        echo "Invalid selection, please try again."
    fi
done

# Extract the selected directory's name.
output_dirname=$(basename "$dir")

# Get the parent directory of the selected directory.
parent_dir=$(dirname "$dir")

# Function to process a directory and convert .ADD files to MiniSEED.
#
# Arguments:
#   $1: The directory containing the .ADD files.
#   $2: The parent directory.
#   $3: The name of the original directory.
procesar_directorio() {
    local dir="$1"
    local parent_dir="$2"
    local output_dirname="$3"

    echo "Processing files from $dir"

    # Count .ADD files in the current directory.
    local files_in_this_dir=$(find "$dir" -type f -name "*.ADD" | wc -l)

    if [ "$files_in_this_dir" -eq 0 ]; then
        echo "No .ADD files found in $dir"
        return
    fi

    echo "Found $files_in_this_dir .ADD files in $dir."

    # Create the output directory in the parent directory.
    output_dir="$parent_dir/MiniSEED_${output_dirname}"
    mkdir -p "$output_dir"
    echo "Output directory created: $output_dir"

    # Create a log file inside the output directory.
    log_file="$output_dir/log__$(date +%Y-%m-%d).log"

    # Redirect stdout and stderr to the log file.
    exec > >(tee -a "$log_file") 2>&1

    processed=0
    find "$dir" -type f -name "*.ADD" | while read file; do
        if [ -f "$file" ]; then
            processed=$((processed + 1))
            percentage=$((processed * 100 / files_in_this_dir))
            echo "[$percentage%] Converting $file to MiniSEED..."

            # Run the cube2mseed command.
            /opt/cubetools-2024.170/bin/cube2mseed --verbose --output-dir="$output_dir" "$file"

            if [ $? -eq 0 ]; then
                echo "File $file converted successfully."
            else
                echo "Error converting $file."
            fi
        fi
    done
    echo "Finished converting files in $dir."

    # Update the global count of processed files.
    total_files_processed=$((total_files_processed + files_in_this_dir))
}

# Start processing.
echo "Starting file processing..."
if [ -d "$dir" ]; then
    procesar_directorio "$dir" "$parent_dir" "$output_dirname"
else
    echo "$dir is not a valid directory."
fi

# Display the total number of processed files.
echo "Output directory: $parent_dir/MiniSEED_${output_dirname}"
echo "Total files processed: $total_files_processed"
echo "Processing completed."
