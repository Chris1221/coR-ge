// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
bool test(arma::vec test2)  {
	
	bool sin = arma::all(test2 == 0);

	return sin;
}
