# DIGOS to MiniSEED Converter

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
