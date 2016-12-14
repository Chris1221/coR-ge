## This analysis is centered around using a new reference panel with more SNPs
#	hopefully attenuating the increase in false positives that we have been 
#	observing in the previous analyses.
#
#	This is going hopefully towards publication eventually. 

# Set up some variables first.
home=/scratch/hpc2862/CAMH/new_corge
hapgen2=$(home)/bin/hapgen2

# The default rule
# 	For now just update the git repo.
.all: $(home)/sim/.done

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
	cd $(home)/ref && $(hapgen2) -h 1000GP_Phase3_chr1.hap.gz \
		-l 1000GP_Phase3_chr1.legend.gz \
		-m genetic_map_chr1_combined_b37.txt \
		-dl 77053 1 1.0 1.0 \
		-n 1000 \
		-int 0 500000000 \
		-o  ../sim/chr1_sim1
