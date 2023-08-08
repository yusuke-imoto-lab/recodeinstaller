
# Installer of RECODE (recodeinstaller)

 "recodeinstaller" enables the user to install the Python version RECODE by using the R reticulate package.
  
 RECODE - resolution of curse of dimensionality in single-cell data analysis : https://github.com/yusuke-imoto-lab/RECODE
 
 
 Ushey K, Allaire J, Tang Y (2023). reticulate: Interface to 'Python'. https://rstudio.github.io/reticulate/, https://github.com/rstudio/reticulate. 
 
 "recodeinstaller" supports the following types of RECODE installation.

- Install Miniconda to create a new RECODE-enabled conda environment (if conda is not installed, recommended).
- Install RECODE to a new or existing conda environment (if conda is installed, recommended).
- Install RECODE to an existing virtualenv environment.
- Install RECODE using a specified Python binary (e.g., local Python, Python embeddable).
 
 
## Installation

You can install "recodeinstaller" with the following command:

``` r
remotes::install_github("yusuke-imoto-lab/recodeinstaller")
```

## Usage

The following command installs the Python version of RECODE.

``` r
library(recodeinstaller)

install_screcode()

```
The user can choose their preferred installation type according to the guidance.
 
After the installation is done, a directory called "recodeloader" is created in the working directory.
This directory contains an R script for loading the RECODE-enabled Python. 



## Tutorial
The "recodeloader" directory contains following files.

- load_recodeenv.R
- install_info.RData (exists only when RECODE is installed using a specified Python binary)


The user can load the created RECODE-enabled Python by running

```r
source("recodeloader/load_recodeenv.R")
```

in the working directory. 
Please make sure that the above source command is run on the R-terminal (not in your script) 
and the "recodeloader" is in the working directory. 

This script executes reticulate::use_conda, reticulate::use_virtualenv or reticulate::use_python 
depending on the type of RECODE installation. Therefore, the created environment can be loaded by running 
these commands directly without using the script. Please refer the reticulate documentation for the detail.

After loading the created environment, the tutorial in the following link can be run (please comment out the "reticulate::use_python" part in the following link).

[Tutorial (Python calling)](https://yusukeimoto.github.io/images/RECODE_R_Tutorials/Run_RECODE_on_R_tutorial3_reticulate.html)


## Note
- The recommended option is to create a conda environment to install RECODE.
- Installing RECODE to virtualenv and environment specified Python binary is limited to existing environments only. Creation of a new environment is not supported in these options.
- The specified Python binary option is for advanced users. You can choose an arbitrary Python to install RECODE to. However, you should do this with great care since changing important Python binaries (e.g., a Python on which other programs depend) may break dependencies and introduce unpredictable errors.
- A dependency error for numba (0.56.4) may occur during the installation. To resolve this, the version of NumPy to be installed is set to be "numpy<1.24,>=1.18". Please note that versions of installed packages may be changed when installing to an existing environment.
- The Python version of a new conda environment to be created can be specified by setting the environment variable "RETICULATE_MINICONDA_PYTHON_VERSION" before running install_screcode. The command below is an example of specifying the conda Python version to version 3.11.

```r
Sys.setenv(RETICULATE_MINICONDA_PYTHON_VERSION = "3.11")
```
