// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::uvec fun(arma::field<std::string> input_field, std::string id){

    // Find where vector equals 5 (for example)
   // uvec index = find( std::strcmp(input_field,id) );

    //return index;
}
