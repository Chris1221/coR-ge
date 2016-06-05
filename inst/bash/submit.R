#!/usr/bin/Rscript

if(!require(devtools)) install.packages("devtools")
devtools::install_github("Chris1221/coR-ge", ref = "devel")

args = commandArgs(trailingOnly=TRUE)

analyze(i = args[1], j = args[2], mode = "ld", test = FALSE, safe = TRUE) 
