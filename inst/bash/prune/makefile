.PHONY: all clean 

/scratch/hpc2862/CAMH/perm_container/prune/prune.controls.gen: generate_gen.sh
	mkdir /scratch/hpc2862/CAMH/perm_container/prune 
	bash $< 

	cd /scratch/hpc2862/CAMH/perm_container/prune
	plink2 --data prune.controls \
		--oxford-single-chr 1 \
		--indep-pairwise 50 5 0.5 \
		--out indep_list
		


clean: 
	rm -rf /scratch/hpc2862/CAMH/perm_container/prune
