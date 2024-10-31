# DIGOS to MiniSEED Converter

![Bash](https://img.shields.io/badge/bash-v4.4-blue.svg)
![CubeTools](https://img.shields.io/badge/CubeTools-2024.170-brightgreen.svg)
![GitHub Issues](https://img.shields.io/github/issues/rotoapanta/digos-to-miniseed-converter)
![Last Commit](https://img.shields.io/github/last-commit/rotoapanta/digos-to-miniseed-converter)
![License](https://img.shields.io/github/license/rotoapanta/digos-to-miniseed-converter)
![GitHub repo size](https://img.shields.io/github/repo-size/rotoapanta/digos-to-miniseed-converter)
![Supported Platforms](https://img.shields.io/badge/platform-Linux%20|%20macOS-green)

## Overview

The **DIGOS to MiniSEED Converter** is a Bash script designed to facilitate the conversion of seismic data files from the DIGOS `.ADD` format into the MiniSEED format using CubeTools. This process ensures that seismic data can be easily analyzed, processed, and visualized using industry-standard tools that support MiniSEED files. 

This script streamlines the conversion process, allowing batch processing of multiple `.ADD` files, and is tailored to support datasets organized across various directories.

## Features

- **Batch Processing**: Automatically processes multiple `.ADD` files from specified directories.
- **Progress Tracking**: Displays conversion progress as a percentage.
- **Custom Output Directory**: Outputs all converted MiniSEED files to a specified directory for easy management.
- **Error Handling**: Ensures smooth processing by skipping problematic files and reporting errors.

## Prerequisites

To successfully run this script, ensure the following requirements are met:

- **CubeTools**: The conversion utility (`cube2mseed`) should be installed at:
  `/opt/cubetools-2024.170/bin/cube2mseed`
- **Bash**: The script is designed to run on Linux systems with Bash.
- **Writable Output Directory**: The script will create the output directory if it does not exist.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rotoapanta/digos-to-miniseed-converter.git
   cd digos-to-miniseed-converter

2. **Ensure CubeTools is Installed**:
Verify that `cube2mseed` is installed and accessible at `/opt/cubetools-2024.170/bin/cube2mseed`.

3. **Update Script Permissions: Make the script executable if necessary**:
   ```bash
   chmod +x digos_to_miniseed_converter.sh

## Usage

1. Prepare `.ADD` Files: Place your `.ADD` files in the following directories (or create your own):
/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/Datos_cedia_infra_nasa
/home/rotoapanta/Documentos/DiGOS/DTA_CEDIA/Datos_cedia_infra_nasa_2
Run the Conversion Script: Execute the script to convert the files:
