// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::vec test(arma::uvec cIndex, arma::mat gen, arma::vec bpVec)  {

	uword i = 0;
	uword index = cIndex(i);

	uvec bp = find(bpVec >= bpVec(index));
	
	mat subset = gen.rows(bp);

	mat genT = subset.t();

	arma::mat other((genT.n_rows / 3), genT.n_cols, fill::zeros);

	for(uword j = 0; j < genT.n_rows; j+=3){
			
		// The new row j / 3 (0, 1, 2, etc.) will be 0* none, 1 * 1, 
		// and 2 x the double minor allele.
		other.row(j/3) = (0 * genT.row(j)) + (1 * genT.row(j+1)) + (2 * genT.row(j+2));
	}
		

	arma::rowvec causal_raw_row = gen.row(index);
	
	arma::colvec causal_raw = causal_raw_row.t();

	arma::vec causal(causal_raw.n_elem/3);
		
	for(uword j = 0; j < causal_raw.n_elem; j+=3){
		causal(j/3) = 0*causal_raw(j) + 1*causal_raw(j+1) + 2*causal_raw(j+2);
	}


	
	return causal;
}
