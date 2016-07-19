#include <stdio.h>
#include <math.h>

NumericVector gen_cor(IntegerVector causal, IntegerMatrix all) {
	
	int nrow = causal.nrow();
	int nsnp = all.ncol();

	NumericVector out(nsnp);

	// Calculate correlation and put into output
	
	for(int i = 0; i < nsnp; i++)
	{
		double x 

}

double ex(NumericMatrix x) {
	double mu = mean(x.col(1));
	return mu;
}
