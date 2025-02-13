#!/bin/bash

# Script Name: digos_to_miniseed_converter.sh
# Description: Converts raw data files (.ADD, .CF0, .CF1, etc.) to MiniSEED format.
# Version: 1.8.0
# Author: Roberto Toapanta
# Date: 2024-09-18
# License: GNU General Public License v3.0

# Script version
script_version="1.8.0"
echo "Script version: $script_version"

while true; do
    # Prompt user to enter the base directory with autocompletion
    echo "Enter the base directory (use TAB for autocompletion):"
    read -e -p "Base directory: " base_dir

    # Validate if the directory exists
    if [ ! -d "$base_dir" ]; then
        echo "Error: Directory does not exist. Please try again."
        continue
    fi

    # Global variable to track the total number of processed files.
    total_files_processed=0

    # Prompt the user to select a directory.
    echo "Select a directory with raw data files to process:"
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

    # Detect available file extensions in the selected directory.
    extensions=$(find "$dir" -type f -name "*.*" | sed -n 's/.*\.\([A-Za-z0-9]*\)$/\1/p' | sort -u)

    # Check if any extensions were found.
    if [ -z "$extensions" ]; then
        echo "No valid files with extensions found in $dir. Please select another directory."
        continue
    fi

    # Display the detected extensions for selection.
    echo "Detected file extensions:"
    select file_extension in $extensions; do
        if [ -n "$file_extension" ]; then
            echo "You selected the extension: .$file_extension"
            break
        else
            echo "Invalid selection, please try again."
        fi
    done

    # Verify if the directory still exists after selection
    if [ ! -d "$dir" ]; then
        echo "Error: The selected directory ($dir) no longer exists. Please select another directory."
        continue
    fi

    # Function to process a directory and convert files with the selected extension to MiniSEED.
    procesar_directorio() {
        local dir="$1"
        local parent_dir="$2"
        local output_dirname="$3"

        echo "Processing .$file_extension files from $dir"

        # Count files with the selected extension before starting
        local files_in_this_dir=$(find "$dir" -type f -name "*.${file_extension}" | wc -l)

        if [ "$files_in_this_dir" -eq 0 ]; then
            echo "No .$file_extension files found in $dir. Please select another directory."
            return
        fi

        echo "Found $files_in_this_dir .$file_extension files in $dir."

        # Create the output directory in the parent directory.
        output_dir="$parent_dir/MiniSEED_${output_dirname}"
        mkdir -p "$output_dir"
        echo "Output directory created: $output_dir"

        # Create a log file inside the output directory.
        log_file="$output_dir/log__$(date +%Y-%m-%d).log"

        # Redirect stdout and stderr to the log file.
        exec > >(tee -a "$log_file") 2>&1

        processed=0
        find "$dir" -type f -name "*.${file_extension}" | while read file; do
            # Verify if the file still exists before processing
            if [ ! -f "$file" ]; then
                echo "Warning: File $file was deleted before processing. Skipping..."
                continue
            fi

            processed=$((processed + 1))
            percentage=$((processed * 100 / files_in_this_dir))
            echo "[$percentage%] Converting $file to MiniSEED..."

            # Run the cube2mseed command.
            /opt/cubetools-2024.354/bin/cube2mseed --verbose --output-dir="$output_dir" "$file"

            if [ $? -eq 0 ]; then
                echo "File $file converted successfully."
            else
                echo "Error converting $file."
            fi
        done

        echo "Finished converting .$file_extension files in $dir."

        # Update the global count of processed files.
        total_files_processed=$((total_files_processed + files_in_this_dir))
    }

    # Start processing.
    echo "Starting file processing..."
    if [ -d "$dir" ]; then
        procesar_directorio "$dir" "$parent_dir" "$output_dirname"
    else
        echo "Error: The selected directory ($dir) is no longer valid. Please select another."
        continue
    fi

    # Display the total number of processed files.
    echo "Output directory: $parent_dir/MiniSEED_${output_dirname}"
    echo "Total files processed: $total_files_processed"
    echo "Processing completed."

    # Ask user if they want to process another directory
    echo "Do you want to process another directory? (y/n):"
    read -r answer
    if [[ "$answer" != "y" ]]; then
        echo "Exiting script."
        break
    fi
done
