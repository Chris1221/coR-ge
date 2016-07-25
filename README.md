`coRge`:  Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments, clean version. 
------------------------------

## Status:

| Branch | Travis-CI | Appveyor | Coverage | CRAN | Downloads | Publication |
| :--- | :---: | :---: | :--: | :---: | :---: | :---: |
| `master` | ![Build Status](https://travis-ci.org/Chris1221/coR-ge.svg?branch=master) | ![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true) | [![codecov.io](https://codecov.io/github/Chris1221/coR-ge/coverage.svg?branch=master)](https://codecov.io/github/Chris1221/coR-ge?branch=master) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/coRge) | ![](http://cranlogs.r-pkg.org/badges/coRge) | GitXiv |
| `devel` |![Build Status](https://travis-ci.org/Chris1221/coR-ge.svg?branch=devel) | [![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true)](https://ci.appveyor.com/project/Chris1221/miner) | [![codecov.io](https://codecov.io/github/Chris1221/coR-ge/coverage.svg?branch=devel)](https://codecov.io/github/Chris1221/coR-ge?branch=devel) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/coRge) | ![](http://cranlogs.r-pkg.org/badges/coRge) | GitXiv | 

-----------------------------------

To install:

```R
if(!require(devtools)) install.packages("devtools")
devtools::install_github("Chris1221/coR-ge")
```

To run:

```R
library(coRge)

coRge::analyze(gen = genEx, summary = exampleSamp, output = "/dev/null") 
```

If everything is configured properly, this should return `0`. If it does, please move on to the quick start guide and tutorial.
