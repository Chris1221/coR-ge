OUT=/home/hpc2862/repos/coR-ge/data
IN=/home/hpc2862/repos/coR-ge/inst/pipelines
B=/home/hpc2862/repos/coR-ge/inst/bash

/home/hpc2862/repos/coR-ge/data/test_run2.txt: $(IN)/bigrun.R	
	for i in 1 2 3 ; do \
		for j in 1 2 3 4 5 6 7 8 9 10 ; do \
			qsub -N test $(B)/submit.sh $$i $$j $(IN)/bigrun.R ; \
		done
	done
		
