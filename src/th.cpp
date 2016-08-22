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
arma::vec th(Rcpp::StringVector strata_rsid, Rcpp::StringVector rsid, Rcpp::NumericVector r2){
	
	// Inputs:
	//
	// strata_rsid is the overall index of rsid returned from stratify()
	// rsid is the rsid column from LdList
	// r2 is the r2 column from LdList
	
	// Create the output vector of th numbers
	arma::vec th(strata_rsid.size(), fill::zeros);

	// Find the indices of where the rsid are in strata_rsid
	for(int i = 0; i < rsid.size(); i++){

		// Pull out each of the RSIDs successively 
		// std::string id = rsid(i);

		// Find the index in strata_rsid where the RSID string is
		// and fill it in with the r2 at the given id.
//		th( arma::find( strata_rsid == rsid(i) ) ) = r2(i);
	}

	// Create duplicate vector to fill in discretized values
	arma::vec out = th;

	out.elem( find( th >= 0.2 ) ).fill(0.2);
	out.elem( find( th >= 0.4 ) ).fill(0.4);
	out.elem( find( th >= 0.6 ) ).fill(0.6);
	out.elem( find( th >= 0.8 ) ).fill(0.8);
	out.elem( find( th >= 0.9 ) ).fill(0.9);
	out.elem( find( th >= 1 ) ).fill(1);
	
	return out;

}
