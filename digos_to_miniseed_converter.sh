#!/bin/bash

# ================================================================
# Script for Converting .ADD Files to MiniSEED Format
# Version: 1.0.7
# Author: Roberto Toapanta
# Date: 2024-09-18
# Description: This script processes .ADD files located in a
#              specified directory and converts them to MiniSEED
#              format using the CubeTools.
# ================================================================

# Script version
script_version="1.0.7"
echo "Script version: $script_version"

# Base directory where directories with .ADD files will be searched
base_dir="/path/to/your/directory/DTA"

# Get the list of subdirectories in base_dir
echo "Select a directory with .ADD files to process:"
select dir in $(find "$base_dir" -type d); do
    if [ -n "$dir" ]; then
        echo "You selected the directory: $dir"
        break
    else
        echo "Invalid selection, please try again."
    fi
done

# Get the current date for the output directory name
current_date=$(date +%Y-%m-%d_%H-%M-%S)

# Count how many .ADD (raw data) files there are in total
raw_data_files=$(find "$dir" -type f -name "*.ADD" | wc -l)

# Output directory for the MiniSEED files, located inside base_dir with the suffix MiniSEED_$current_date
output_dir="$base_dir/MiniSEED_$current_date"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"
echo "Output directory created: $output_dir"

# Create a log file inside the output directory
log_file="$output_dir/log__$(date +%Y-%m-%d).log"

# Redirect stdout and stderr to the log file
exec > >(tee -a "$log_file") 2>&1

# Global counter to track processed files
total_processed_files=0

# Function to process a directory with progress percentage
procesar_directorio () {
    local dir=$1
    echo "Processing files from $dir"
    
    # Count how many .ADD files there are in total before processing
    total_files=$(find "$dir" -type f -name "*.ADD" | wc -l)
    
    # If no .ADD files are found, exit
    if [ "$total_files" -eq 0 ]; then
        echo "No .ADD files found in $dir"
        return
    fi
    
    echo "Found $total_files .ADD files in $dir."

    # Progress counter
    processed=0

     # Process the files
    find "$dir" -type f -name "*.ADD" | while read file
    do
        if [ -f "$file" ]; then  # Check to ensure it's a file
            processed=$((processed + 1))
            percentage=$((processed * 100 / total_files))
            echo "[$percentage%] Converting $file to MiniSEED..."

            # Run the cube2mseed command
            /opt/cubetools-2024.170/bin/cube2mseed --verbose --output-dir="$output_dir" "$file"
            
            # Check if the conversion was successful
            if [ $? -eq 0 ]; then
                echo "File $file converted successfully."
            else
                echo "Error converting $file."
            fi
        fi
    done

    # Increase the global processed files counter
    total_processed_files=$((total_processed_files + processed))
    echo "Finished converting files in $dir."
}

# Process the selected directory
echo "Starting file processing..."
if [ -d "$dir" ]; then
    procesar_directorio "$dir"
else
    echo "$dir is not a valid directory."
fi

# Display total processed files
echo "Output directory: $output_dir"
echo "Total files processed: $total_files."
echo "Processing completed."
