// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>
#include <string>
#include <sstream>

// Patch for std::to_string() issue
// See here: http://stackoverflow.com/questions/12975341/to-string-is-not-a-member-of-std-says-so-g
namespace patch
{
    template < typename T > std::string to_string( const T& n )
    {
        std::ostringstream stm ;
        stm << n ;
        return stm.str() ;
    }
}


#include<iostream>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::vec assoc(arma::mat gen, arma::colvec y){
	
	// Initialize output as a vector.
	arma::vec outputList(gen.n_rows);

	// Split regression into each row of the gen file
	// meaning each SNP is regressed seperately.
	for(uword i = 0; i < gen.n_rows; i++){

		arma::rowvec geno_row = gen.row(i);
		arma::vec geno = geno_row.t();
		arma::vec X((geno.n_elem / 3), 1, fill::zeros);
		
		for(uword j = 0; j < geno.n_elem; j+=3){

			X(j/3) = 0*geno(j) + 1*geno(j+1) + 2*geno(j+2);

		}

		arma::mat X2(X.n_elem, 2);
		X2.col(0) = vec(X.n_elem, fill::ones);
		X2.col(1) = X;

		arma::colvec coef = arma::solve(X2, y);
		arma::colvec resid = y - X2*coef;
		
		int n = X2.n_rows, k = X2.n_cols;

		double sig2 = arma::as_scalar( arma::trans(resid)*resid/(n-k) );
                                                // std.error of estimate
    		arma::colvec stderrest = arma::sqrt( sig2 * arma::diagvec( arma::pinv(arma::trans(X2)*X2)) );

		arma::mat output(coef.n_elem, 2);
		output.col(0) = coef;
		output.col(1) = stderrest;

		double t = output(1,0) / output(1,1);
		
		std::string name = patch::to_string(i);
		
		outputList[i] = t;
	}

	return outputList;

}
