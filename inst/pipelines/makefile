OUT=/home/hpc2862/repos/coR-ge/data
IN=/home/hpc2862/repos/coR-ge/inst/pipelines
B=/home/hpc2862/repos/coR-ge/inst/bash

all: priority full

full: $(IN)/bigrun.R	
	num1=1 ; while [[ $$num1 -le 3 ]] ; do \
        num2=1 ; while [[ $$num2 -le 10 ]] ; do \
		qsub -N corge_$(num1)_$(num2) $(B)/submit.sh $$num1 $$num2 $(IN)/bigrun.R ; \
        	((num2 = num2 + 1)) ; \
        	done ; \
	((num1 = num1 + 1)) ; \
	done

priority: $(IN)/bigrun.R
	num1=1 ; while [[ $$num1 -le 3 ]] ; do \
        num2=1 ; while [[ $$num2 -le 10 ]] ; do \
		qsub -N corge_$$num1_$$num2 $(B)/submit.sh $$num1 $$num2 $(IN)/bigrun.R ; \
        	((num2 = num2 + 1)) ; \
        	done ; \
	((num1 = num1 + 1)) ; \
	done

pri2: $(IN)/bigrun_priority2.R
	num1=1 ; while [[ $$num1 -le 3 ]] ; do \
        num2=1 ; while [[ $$num2 -le 10 ]] ; do \
		qsub -N priority3 $(B)/submit.sh $$num1 $$num2 $(IN)/bigrun_priority2.R ; \
        	((num2 = num2 + 1)) ; \
        	done ; \
	((num1 = num1 + 1)) ; \
	done

genes: $(IN)/gene_analysis.R
	num1=1 ; while [[ $$num1 -le 3 ]] ; do \
        num2=1 ; while [[ $$num2 -le 10 ]] ; do \
		qsub -N gene_analysis $(B)/submit.sh $$num1 $$num2 $(IN)/gene_analysis.R ; \
        	((num2 = num2 + 1)) ; \
        	done ; \
	((num1 = num1 + 1)) ; \
	done
