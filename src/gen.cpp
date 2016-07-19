// [[Rcpp::depends(RcppArmadillo)]]

#include <Rcpp.h>
#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

// [[Rcpp::export]]
NumericVector gen_cor(IntegerVector causal, IntegerMatrix all) {
	
	int nrow = causal.nrow();
	int nsnp = all.ncol();


	NumericVector out(nsnp);
	
	for(int i = 0; i < nsnp; i++){ 
		IntegerVector other = all.col(i);

		double corr = arma::cor(causal, other);

		out(i) = corr;
	}

	return(out)
}
