library(coRge)

h2 = 0.5
pc = 0.75
pnc = 0.2
nc = 500


for( i in c(50, 500, 5000) ){

	analyze(i = i,
		j = j,
		h2 = h2,
		pc = pc,
		pnc = pnc,
		nc = nc,
		local = TRUE,
		gen = gen,
		summary = summary,
		mode = "ld",
		output = "~repos/coR-ge/data/raw/new_panels.txt")
}
