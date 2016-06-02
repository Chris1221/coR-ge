# coR-ge [![Travis-CI Build Status](https://travis-ci.org/Chris1221/coR-ge.svg?branch=master)](https://travis-ci.org/Chris1221/coR-ge) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/Chris1221/coR-ge?branch=master&svg=true)](https://ci.appveyor.com/project/Chris1221/coR-ge) [![Coverage Status](https://img.shields.io/codecov/c/github/Chris1221/coR-ge/master.svg)](https://codecov.io/github/Chris1221/coR-ge?branch=master)

Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments, clean version. 
------------------------------

To install:

```R
if(!require(devtools)) install.packages("devtools")
devtools::install_github("Chris1221/coR-ge", ref = "devel")
```

Adding optional `mode` arguement to incorporate different methods for running. 

E.g.

```R
coRge::analyze(i = 3, j = 3, mode = NULL) # or "default" 
coRge::analyze(i = 3, j = 3, mode = "group", group_name = "k")
coRge::analyze(i = 3, j = 3, mode = "tp_gradient")
```

All commits should be signed.
