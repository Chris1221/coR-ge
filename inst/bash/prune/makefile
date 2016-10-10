.PHONY: all clean 

/scratch/hpc2862/CAMH/perm_container/prune/prune.controls.gen: generate_gen.sh
	mkdir /scratch/hpc2862/CAMH/perm_container/prune 
	bash $< 

	cd /scratch/hpc2862/CAMH/perm_container/prune
	plink2 --data prune.controls \
		--oxford-single-chr 1 \
		--indep-pairwise 50 5 0.5 \
		--out indep_list
		
	plink2 --data prune.controls \ 
		--oxford-single-chr 1 \
		--extract indep_list.prune.in \ 
		--recode oxford \ 
		--out pruned_input
	
	# Get rid of junk files

	rm -f indep_list.*
	rm -f prune.*

	# This is to see if it works. If this errors then the qsub will also error

	Rscript -e 'library(coRge); library(data.table)' \
		-e 'gen <- as.data.frame( data.table::fread("pruned_input.gen", h = F, sep = " "))' \
		-e 'summary <- fread("/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", h = T)' \
		-e 'analyze(i = 1, j = 1, local = T, gen = gen, summary = summary, mode = "ld", output = "~/repos/coR-ge/inst/data/raw/pruned.txt")'

	qsub -N prune submit.sh
	

clean: 
	rm -rf /scratch/hpc2862/CAMH/perm_container/prune
