# DIGOS to MiniSEED Converter

![Bash](https://img.shields.io/badge/bash-v4.4-blue.svg)
![CubeTools](https://img.shields.io/badge/CubeTools-2024.354-brightgreen.svg)
![GitHub issues](https://img.shields.io/github/issues/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter)
![Last Commit](https://img.shields.io/github/last-commit/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter)
![License](https://img.shields.io/github/license/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter)
![GitHub repo size](https://img.shields.io/github/repo-size/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter)
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
  `/opt/cubetools-2024.354/bin/cube2mseed`
- **Bash**: The script is designed to run on Linux systems with Bash.
- **Writable Output Directory**: The script will create the output directory if it does not exist.

## Installation

### Step 1: Install Java 1.8

CubeTools requires Java 1.8. Follow these steps to install it:

1. **Update the package list**:

Open a terminal and run the following command to update the package list:

```bash
   $ sudo apt update
```

2. **Install OpenJDK 8**:

Install the OpenJDK 8 package with the following command:

```bash
   $ sudo apt install openjdk-8-jdk
```

3. **Verify and select Java 1.8 for CubeTools**:

Set Java 1.8 as the default version by running:

```bash
   $ sudo update-alternatives --config java
```
Select Java 1.8 when prompted.

4. **Configure CubeTools to use Java 1.8**:

Add the following environment variable to configure CubeTools to use Java 1.8:

```bash
   export GIPPTOOLS_JAVA=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
```
### Step 2: Download and Install CubeTools

1. **Download CubeTools**: 

Visit the official CubeTools website and download the latest version for your platform. Ensure compatibility with your operating system. Here is the link to download CubeTools:
   
   [CubeTools Download Page](https://digos.eu/seismology/)

2. **Verify the downloaded file**:

```bash
   $ file cubetools-2024.354-unix.tar.gz
```
3. **Extract the .tar file**:

Extract the contents of the tar file using tar:

```bash
   $ tar -xzvf cubetools-2024.354-unix.tar
```
4. **Move the extracted directory to a suitable location**:

Move the CubeTools to `/opt` (which is a common place to install software not in your system's repositories).

5. **Update the PATH variable**:

Add the path to the CubeTools executable to your system's PATH variable. This will allow you
to run CubeTools from anywhere.

```bash
   echo 'export PATH=/opt/cubetools-2024.354/bin:$PATH' >> ~/.bashrc
```

Save and close the file (Ctrl + O to save and Ctrl + X to exit).

6. **Update the environment**:

Update the environment with:

```bash
   $ source ~/.bashrc
```

7. **Set execution permissions for cube2mseed**:

Ensure that cube2mseed has execution permissions. If it is not executable, grant permissions with the following command:

```bash
   $ chmod +x /opt/cubetools-2024.354/bin/cube2mseed
```

8. **Verify Installation**:

Once installed, verify by running the following command:

```bash
   $ cube2mseed --version
```

You should see output indicating the version of CubeTools installed.

<p align="center">
  <img src="images/image_1.png" width="500" />
  <br>
  <em>Figure 1: CubeTools version verification output</em>
</p>

### Step 3: Clone the Repository

1. **Clone the Repository**:

```bash
   $ git clone https://github.com/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter.git
```

```bash
   $ cd DiGOS_DataCube_to_MiniSEED_Converter
```

2. **Ensure CubeTools is Installed**:

Verify that `cube2mseed` is installed and accessible at `/opt/cubetools-2024.354/bin/cube2mseed`.

3. **Update Script Permissions: Make the script executable if necessary**:

```bash
   $ chmod +x digos_to_miniseed_converter.sh
```

## Usage

1. **Select a Base Directory**:

Run the script and enter the base directory where your raw data files are stored. You can use **TAB** for autocompletion.

```bash
   $ ./digos_to_miniseed_converter.sh
```
You will be prompted to enter a base directory:

```bash
   Enter the base directory (use TAB for autocompletion):
   Base directory: /path/to/your/directory/DTA/file_1
```

2. **Select a Directory with Raw Data Files**

Once you enter a valid base directory, the script will list all available subdirectories.

Example output:

```bash
   Select a directory with raw data files to process:
   1) /path/to/your/directory/DTA/file_1/raw_data_1
   2) /path/to/your/directory/DTA/file_1/raw_data_2
   3) /path/to/your/directory/DTA/file_1/raw_data_3
```
Select the directory by typing the corresponding number.

3. **Choose the File Extension to Convert**

The script will automatically detect available file extensions within the selected directory and prompt you to choose one.

Example:

```bash
   Detected file extensions:
   1) ADD
   2) CF0
   3) CF1
   Select a number: 2
```
This ensures only files with the chosen extension are processed.

4. **Script Execution**: 

Once a directory and extension are selected, the script will begin processing the files and convert them to MiniSEED format.

```bash
   Starting file processing...
   Processing .CF0 files from /path/to/your/directory/DTA/file_1
   Found 3 .CF0 files in /path/to/your/directory/DTA/file_1/.
   [33%] Converting /path/to/your/directory/DTA/file_1/raw_data_1.CF0 to MiniSEED...
   ...
   ...
   File /path/to/your/directory/DTA/file1/raw_data_1.CF0 converted successfully.
   [66%] Converting /path/to/your/directory/DTA/file_1/raw_data_2.CF0 to MiniSEED...
   ...
   ...
   File /path/to/your/directory/DTA/file1/raw_data_2.CF0 converted successfully.
   [100%] Converting /path/to/your/directory/DTA/file_1/raw_data_3.CF0 to MiniSEED...
   ...
   ...
   File /path/to/your/directory/DTA/file1/raw_data_3.CF0 converted successfully.
   Finished converting .CF0 files in /path/to/your/directory/DTA/raw_data_1.
   Output directory: /home/rotoapanta/Documentos/DiGOS/DTA/MiniSEED_file_1
   Total files processed: 3
   Processing completed.
```

3. **Output Files**: 

Converted MiniSEED files will be stored in a new subdirectory within the selected directory.

```bash
  /path/to/your/directory/DTA/MiniSEED_file_1/
         ├── c0cf0250210165704.pri0
         ├── c0cf0250210165704.pri1
         ├── c0cf0250210165704.pri2
         ├── log_YYYY-MM-DD.log
```
The directory name follows this format:

```bash
  MiniSEED_{original_directory_name}
```

The .pri0, .pri1, and .pri2 files are the converted MiniSEED outputs.

A log file is created, detailing the processing steps, conversion status, and any errors.

5. **Handling File Deletion**

If a file is deleted after selecting the directory but before processing, the script will detect it and skip the missing file instead of failing.

```bash
  Warning: File /path/to/your/directory/DTA/file1/raw_data_3.CF0 was deleted before processing. Skipping...
  [50%] Converting /path/to/your/directory/DTA/file1/raw_data_1.CF0 to MiniSEED...
  ...
  ...

  File /path/to/your/directory/DTA/file1/raw_data_1.CF0 converted successfully.
  [100%] /path/to/your/directory/DTA/file1/raw_data_2.CF0 to MiniSEED...
  ...
  ...
  File /path/to/your/directory/DTA/file1/raw_data_2.CF0 converted successfully.
```

6. **Processing Multiple Directories**

Once the script finishes processing a directory, it will ask if you want to process another directory.

```bash
Do you want to process another directory? (y/n): y
```

If "y", the script will restart the selection process without exiting.

4. **Log Files**: 

A log file will be created in the same directory as the output files, detailing the processing steps, conversion status, and any errors.
   
```bash
   /path/to/your/directory/DTA/MiniSEED_{original_directory_name}/log_YYYY-MM-DD.log)
```

This approach ensures the user knows how to select a directory and what to expect from the script.

## Troubleshooting

- Permission Issues: Ensure the output directory is writable. You can adjust permissions with:

```bash
   chmod -R 755 /path/to/your/directory/DTA/MiniSEED_{original_directory_name}/
```
- Missing Dependencies: Verify that `cube2mseed` is installed and accessible at `/opt/cubetools-2024.357/bin/cube2mseed`

## Feedback

If you have any feedback, please reach out to us at robertocarlos.toapanta@gmail.com

## Support

For support, email robertocarlos.toapanta@gmail.com or join our Discord channel.

## Contributing

We welcome contributions to improve this script. Please follow these steps:

1. **Fork the Repository**: 

Click on the "Fork" button at the top right of this page to create a copy of this repository on your GitHub account.

2. **Clone the Repository**: 

Clone your forked repository to your local machine.

```bash
   $ git clone https://github.com/rotoapanta/DiGOS_DataCube_to_MiniSEED_Converter.git
```

3. **Create a new branch**:

```bash
   $ git checkout -b feature/your-feature-name
```

4. **Make your changes and commit**:

```bash
   $ git commit -m "Add your detailed description here"
```

5. **Push to your branch**:

```bash
   $ git push origin feature/your-feature-name
```

6. **Open a Pull Request**:

Go to your repository on GitHub.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Authors

- [@rotoapanta](https://github.com/rotoapanta)

## More Info

* [Official documentation for DiGOS, Portafolio Seismic Measurement Equipment](https://digos.eu/seismology/)

## Links

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/roberto-carlos-toapanta-g/)
[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/rotoapanta)
