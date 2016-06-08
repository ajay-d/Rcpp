library(Rcpp)
library(magrittr)
library(devtools)

find_rtools()
session_info()

system('g++ -v')
system('make -v')

system('where make')
system("java -version")
Sys.getenv('PATH')

code <- '
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
std::map<std::string, int> map_test (){
  std::map<std::string, int> x;

  //Must be single quotes
  x["foo"]=7;
  x["bar"]=2;
  
  return x;
}'
sourceCpp(code=code)
map_test()

code <- '
#include <Rcpp.h>

using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
map<string, int> map_test (){
  map<string, int> x;

  //Must be single quotes
  x["foo"]=7;
  x["bar"]=2;
  
  return x;
}'
sourceCpp(code=code)
map_test()

code <- '
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector vec_sum (NumericVector x){
  double total = 0;
  NumericVector y;
  NumericVector z;

  for(int i = 0; i < x.size(); ++i) {
    total += x[i];
  }

  //++i will increment the value of i, and then return the incremented value.
  for(int i = 0; i < x.size(); ++i) {
    y.push_back(x[i]);
  }

  //i++ will increment the value of i, but return the original value that i held before being 
  for(int i = 0; i < x.size(); i++) {
    z.push_back(x[i]);
  }
  
  //return x;
  //return y;
  return z;
}'
sourceCpp(code=code)
vec_sum(1:10)

code <- '
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
std::vector<std::map<std::string, int> > vec_maps (){
  std::map<std::string, int> m1;
  std::map<std::string, int> m2;
  std::vector<std::map<std::string, int> > v;
  
  m1["a"]=1;
  m1["b"]=2;
  m1["c"]=3;

  m2["x"]=7;
  m2["y"]=8;
  m2["z"]=9;
  

  v.push_back(m1);
  v.push_back(m2);
  return v;
}'

sourceCpp(code=code)
vec_maps() %>% str
vec_maps()[[1]]


code <- '
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
double map_sum (){
  std::map<std::string, int> m1;
  std::map<std::string, int> m2;
  NumericVector v;
  
  m1["a"]=1;
  m1["b"]=2;
  m1["c"]=3;

  m2["x"]=7;
  m2["y"]=8;
  m2["z"]=9;

  double total = 0;
  std::map<std::string, int>::iterator it;

  for(it = m1.begin(); it != m1.end(); ++it) {
    total += (*it).second;
  }

  //auto need cpp11 plugin
  auto it_2 = m1.begin();

  for(it_2; it_2 != m1.end(); ++it_2) {
    total += (*it_2).second;
  }
  
  //total = 0;
  for(auto it_3 : m1) {
    total += it_3.second;
  } 
  
  return total;

}'
sourceCpp(code=code)
map_sum() %>% str



