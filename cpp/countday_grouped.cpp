// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <unordered_map>
using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
DataFrame countdays_grouped (DataFrame df){
  NumericVector reported = df["Reported"];
  NumericVector closed = df["Closed"];
  vector<string> group = df["group"];
  
  //count groups
  map<string, int> n_groups;
  int n = group.size();
  for (int i = 0; i < n; i++) {
    n_groups[group[i]]++;
  }
  
  //Reformat to two seperate vectors
  vector<string> keys;
  vector<int> vals;
  
  map<string, int>::iterator it;
  
  for(it = n_groups.begin(); it != n_groups.end(); ++it) {
    keys.push_back((*it).first);
    vals.push_back((*it).second);  
  }

  return DataFrame::create(_["days"] = keys, _["counts"] = vals);
}
