OUT=/home/hpc2862/repos/coR-ge/data
IN=/home/hpc2862/repos/coR-ge/inst/pipelines
B=/home/hpc2862/repos/coR-ge/inst/bash

/home/hpc2862/repos/coR-ge/data/test_run2.txt: $(IN)/bigrun.R	
	num1=1 ; while [[ $$num1 -le 4 ]] ; do \
        num2=1 ; while [[ $$num2 -le 3 ]] ; do \
		qsub -N test $(B)/submit.sh $$num1 $$num2 $(IN)/bigrun.R ; \
        	((num2 = num2 + 1)) ; \
        	done ; \
	((num1 = num1 + 1)) ; \
	done		
