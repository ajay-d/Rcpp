#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
DataFrame countdays_std_noimport (DataFrame df){
  NumericVector reported = df["Reported"];
  NumericVector closed = df["Closed"];
  
  std::map<int, int> counts;
  int n = reported.size();
  
  for (int i = 0; i < n; i++) {
    double row_st = ceil(reported[i]);
    double row_end = floor(closed[i]);
    
    IntegerVector xx = seq(row_st,row_end);
    int xx_n = xx.size();
    for (int j = 0; j < xx_n; j++) {
      counts[xx[j]]++;
    }
  }
    
  //Reformat to two seperate vectors
  std::vector<int> keys;
  keys.reserve(counts.size());
  std::vector<int> vals;
  vals.reserve(counts.size());
  
  std::map<int, int>::iterator it;
  
    for(it = counts.begin(); it != counts.end(); ++it) {
    keys.push_back((*it).first);
    vals.push_back((*it).second);  
  }
  //return counts;
  //return List::create(_["days"] = keys, _["counts"] = vals);
  return DataFrame::create(_["days"] = keys, _["counts"] = vals);
}
