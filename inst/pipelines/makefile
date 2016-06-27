OUT=/home/hpc2862/repos/coR-ge/data
IN=/home/hpc2862/repos/coR-ge/inst/pipelines
B=/home/hpc2862/repos/coR-ge/inst/bash

/home/hpc2862/repos/coR-ge/data/test_run2.txt: $(IN)/bigrun.R
	qsub -N test $(B)/submit.sh 3 3 $(IN)/bigrun.R
