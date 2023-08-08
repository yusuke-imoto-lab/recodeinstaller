message("Load installed Python RECODE.")
script_dir <- dirname(sys.frame(1)$ofile)
RData <- file.path(script_dir, "install_info.RData")
if (!file.exists(RData)) stop("Installation .RData file was not found.")
python <- get(load(RData))

reticulate::use_python(python)
