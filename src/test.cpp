// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
bool test(arma::vec geno)  {
	
        arma::vec X((geno.n_elem / 3), fill::zeros);

        for(uword j = 0; j < geno.n_elem; j+=3){

                X(j/3) = 0*geno(j) + 1*geno(j+1) + 2*geno(j+2);

        }
	
	bool zeros = arma::all(X == 0);
	bool ones = arma::all(X == 1);
	bool twos = arma::all(X == 2);

	bool singular = (zeros || ones || twos);
	
	return singular;

}
