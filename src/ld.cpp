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

		// Just for now as a test
		arma::uvec ldIndex = arma::find(gen.col(3) > gen(index, 3)); 
	
	
//	}

	return ldIndex ;
}
