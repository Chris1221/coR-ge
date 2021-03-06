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
Rcpp::List returnLD(arma::uvec cIndex, arma::mat gen, arma::vec bpVec) {

	int nCausal = cIndex.n_elem;
	
	// Create a list for the output to be stored in.
	// We need a list because each of the elements is a different 
	// length.

	// Not sure if the list type is the problem. It might be.
	Rcpp::List output;

	for(uword i = 0; i < nCausal; i++){
	
		// Give position of first element.
		// Remember that indexing starts at 0, not 1.
		uword index = cIndex(i);

		// Return the column of base pair positions and the basepair position
		// at causal SNP i index.
		//
		// This is still a test because I dont think that the logical
		// selection was working perfectly
		
		arma::uvec ldIndex = arma::find((bpVec > bpVec(index)-500000) && (bpVec < bpVec(index) + 500000));
 
		// This gives us the indices of which SNPs are within 500kb of 
		// the causal SNP.
		// So now we have to subset the matrix to just include these, 
		// as including anything else would be useless calculation
		
		mat subset = gen.rows(ldIndex);

		// Now that we have the collection of useful entries, we must
		// transform them into the R format
		//
		// 1. Cut off first 5 rows (but will need to save the indexes to recover
		//    these later)
		
		// 2. Transpose (will have to do it at some point)
		
		arma::mat genT = subset.t();

		// 3. Cooerce
		//
		// New output will have 1 for every three rows (with rows being the
		// old columns. It will have the same number of columns, as we aren't
		// changing the SNPs at all.
		
		arma::mat other((genT.n_rows / 3), genT.n_cols, fill::zeros);

		for(uword j = 0; j < genT.n_rows; j+=3){
			
			// The new row j / 3 (0, 1, 2, etc.) will be 0* none, 1 * 1, 
			// and 2 x the double minor allele.
			other.row(j/3) = (0 * genT.row(j)) + (1 * genT.row(j+1)) + (2 * genT.row(j+2));
		}
	
		// Now that this preprocessing is accomplished, we can bring in
		// the cor_gen.cpp function.
		//
		// Note that we won't directly import it, merely use the code, 
		// because I don't actually know how to do that.
		//
		// Ideally I would do all this preprocessing at the same time as
		// above but I can't figure out how to do it right now.

		// We create a new vector with as many entries as there are SNPs.
		// arma::vec out(other.n_cols);

		// Now create the "real" vector
		// Using the same process as above
		arma::rowvec causal_raw_row = gen.row(index);
		
		arma::colvec causal_raw = causal_raw_row.t();

		arma::vec causal(causal_raw.n_elem/3);
		
		for(uword j = 0; j < causal_raw.n_elem; j+=3){
			causal(j/3) = 0*causal_raw(j) + 1*causal_raw(j+1) + 2*causal_raw(j+2);
		}

		// Now we have causal and other
		//
		// vec causal = Vector of dosage for the causal SNP that we
		//              have been looking for.
		// mat other = All the other SNP data. Note that causal IS 
		// 		included in this. I will have to figure out 
		// 		how to deal with this soon.
		//
		// Now move on to actually calculating the correlation.
		
		// For each column in the all matrix
		//
		// 1. Create a new vector out of the column
		// 2. Calculate correlation between causal and that column
		// 3. Put that into out
			
		arma::vec out(other.n_cols);

		for(uword j = 0; j < other.n_cols; j++){ 
			
			arma::vec otherVec = other.col(j); // 1

			arma::mat temp = arma::cor(causal, otherVec); // 2

			out(j) = pow(temp(0,0),2); // 3

		}
		
		//cout << out << "\n";
		
		arma::mat outMat(ldIndex.n_elem, 2);

		outMat.col(0) = arma::conv_to<vec>::from(ldIndex)+ 1;
		outMat.col(1) = out;

		std::string name = patch::to_string(i);

		output[name] = outMat;
	

	}

	return output ;
}
