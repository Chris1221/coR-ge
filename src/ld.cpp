// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::uvec returnLD(arma::vec cIndex, arma::mat gen) {

//	int nCausal = cIndex.n_elem;

//	for(int i; i < nCausal; i++){
	
		int index = cIndex(1);
		arma::vec bpCol = gen.col(3);
		double bp = gen(index, 3);
		// Just for now as a test
		arma::uvec ldIndex = arma::find(bpCol > bp); 
	
	
//	}

	return ldIndex ;
}
