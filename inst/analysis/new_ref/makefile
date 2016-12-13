## This analysis is centered around using a new reference panel with more SNPs
#	hopefully attenuating the increase in false positives that we have been 
#	observing in the previous analyses.
#
#	This is going hopefully towards publication eventually. 

# Set up some variables first.
hapgen2=
home=/scratch/hpc2862/CAMH/new_corge


# The default rule
# 	For now just update the git repo.
.all: git

# Git add rule
# 	
git:
	cd ../../.. && git add -A
	git commit -am "update coRge for new analysis see changelog" 

# Download and unpack the reference files.
$(home)/ref/.done: 
	cd $(home)/ref && wget https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.tgz 
	cd $(home)/ref && tar -xvzf 1000GP_Phase3.tgz
	cd $(home)/ref/1000GP_Phase3 && mv * ../
	cd $(home)/ref && rm -rf 1000GP_Phase3.tgz 1000GP_Phase3
	touch $(home)/ref/.done # Done

# This is the simulation protocol
#	Note that the target is a placeholder generated at the end of the simulation
#	as opposed to any of the actual files for the sake of simplicity.
$(home)/sim/.done: $(home)/ref/.done 
	mkdir -p $(home)/sim
	$(hapgen2) -h 
	/home/hpc2862/Programs/hapgen2 -h pilot1.jun2010.b36.CEU.chr1.snpfilt.haps -l pilot1.jun2010.b36.CEU.chr1.snpfilt.legend -m genetic_map_chr1_combined_b36.txt -dl 77053 1 1.0 1.0 -n 1000 0 -int 0 500000000 -o /scratch/hpc2862/CAMH/perm_container/container_${i2}_${SGE_TASK_ID}/chr1_block_${i2}_perm_${j2}_k_${SGE_TASK_ID}


