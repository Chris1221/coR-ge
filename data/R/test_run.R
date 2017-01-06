#!/usr/bin/Rscript

zz <- file("~/repos/coR-ge/data/test_run.sink", open = "wt")

sink(zz)
sink(zz, type = "message")

if(!require(devtools)) install.packages("devtools")
devtools::install_github("Chris1221/coR-ge", ref = "devel")
library(coRge)

library(dplyr)
library(foreach)
library(magrittr)
library(data.table)

for(h2 in seq(0.1, 0.9, by = 0.1)){

	coRge::analyze(i = 3, j = 3, h2 = h2)
	
	}

sink(type = "message")
sink()

system("touch ~/repos/coR-ge/data/done")
