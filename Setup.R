
# UK Proteostasis Workshop - November 2026
# Jatin Burniston

# Run this whole script in RStudio before the workshop

# R version 4.6.0 is required for the current release of Bioconductor
if (getRversion() < "4.6.0") stop("Please update R to 4.6.0 or later")

# specify the CRAN mirror site to use
options(repos = c(CRAN = "https://cloud.r-project.org"))

# override the default 60 second limit to ensure download of large packages
options(timeout = 600)

# always use pre-built binary packages on Windows and macOS; never ask about compiling from source
options(install.packages.compile.from.source = "never")

# packages install from CRAN
cran_pkgs <- c("arrow",         # required for reading parquet files from DIA-NN
               "dplyr", 		    # used for data wrangling
			         "tidyr", 		    # used for data wrangling
			         "ggplot2",		    # used for plotting data
			         "ggrepel",       # used for annotating volcanoplots
			         "BiocManager")   # required for installing Bioconductor packages
			   
# packages installed from Bioconductor			    
bioc_pkgs <- c("QFeatures", 	   # used to create containers for proteomics data
			         "msqrob2",        # used for statistical analyses
			         "ComplexHeatmap", # used for constructing heatmaps
			         "STRINGdb")       # used for enrichment and network analyses

# create function to check T/F whether packages exist
check <- function(pkgs) vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)

# check for CRAN packages and if necessary install required packages
if (any(!check(cran_pkgs))) install.packages(cran_pkgs[!check(cran_pkgs)])

# Stop if BiocManager is not available
if (!check("BiocManager")) stop("BiocManager was not installed")

# check for Bioconductor packages and if necessary install required packages
if (any(!check(bioc_pkgs))) BiocManager::install(bioc_pkgs[!check(bioc_pkgs)], update = FALSE, ask = FALSE)
 
# create list of all packages 
all_pkgs <- c(cran_pkgs, bioc_pkgs)

# write T/F per package install
ok <- check(all_pkgs)

# confirm packages are installed or if a package failed show the error message
if (all(ok)) {
  message("Setup OK - R version ", getRversion())
} else { 
  for (pkg in all_pkgs[!ok]) {
    tryCatch(
      loadNamespace(pkg),
      error = function(error_message) {
        message("Could not load ", pkg, ": ", conditionMessage(error_message))
      }
    )
  }
}
