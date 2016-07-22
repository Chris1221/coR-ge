// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
bool test(arma::vec test2)  {
	
	bool zeros = arma::all(test2 == 0);
	bool ones = arma::all(test2 == 1);
	bool twos = arma::all(test2 == 2);

	bool singular = (zeros || ones || twos);
	
	return singular;
}
