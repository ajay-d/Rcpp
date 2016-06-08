// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <unordered_map>
using namespace Rcpp;

// [[Rcpp::export]]
DataFrame countdays_m (NumericMatrix x){
  std::unordered_map<int, int> counts;
  int n = x.nrow();
  
  for (int i = 0; i < n; i++) {
    NumericVector cur_row = x.row(i);
    double row_st = ceil(cur_row[0]);
    double row_end = floor(cur_row[1]);
    
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
  
  for(auto kv : counts) {
    keys.push_back(kv.first);
    vals.push_back(kv.second);  
  }
  //return counts;
  //return List::create(_["days"] = keys, _["counts"] = vals);
  return DataFrame::create(_["days"] = keys, _["counts"] = vals);
}

// [[Rcpp::export]]
DataFrame countdays (DataFrame df){
  NumericVector reported = df["Reported"];
  NumericVector closed = df["Closed"];
  
  std::unordered_map<int, int> counts;
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
  
  for(auto kv : counts) {
    keys.push_back(kv.first);
    vals.push_back(kv.second);  
  }
  //return counts;
  //return List::create(_["days"] = keys, _["counts"] = vals);
  return DataFrame::create(_["days"] = keys, _["counts"] = vals);
}
