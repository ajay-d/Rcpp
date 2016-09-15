rm(list=ls(all=TRUE))

library(dplyr)
library(tidyr)
library(RcppParallel)
library(microbenchmark)

code <- "
// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>
#include <Rcpp.h>
using namespace Rcpp;

//define a small functor that computes the logarithm of a value
struct Log {
  double operator()(double value) { return log(value); }
};

struct LogWorker : public RcppParallel::Worker
{
  RcppParallel::RVector<double> input, output;

  // initialize inputs
  LogWorker(Rcpp::NumericVector input, Rcpp::NumericVector output)
    : input(input), output(output) {}

  // define work (accepts a range of items to work on)
  void operator()(std::size_t begin, std::size_t end) {
    std::transform(input.begin() + begin,
                   input.begin() + end,
                   output.begin() + begin,
                   Log());
  }
};

// [[Rcpp::export]]
NumericVector parallelLog(NumericVector input)
{
  // allocate our output vector
  NumericVector output = no_init(input.size());

  // construct our worker
  LogWorker worker(input, output);

  // give 'parallelFor' the range of values + our worker
  RcppParallel::parallelFor(0, input.size(), worker);

  // return to R
  return output;
}

// [[Rcpp::export]]
NumericVector Log_c(NumericVector input)
{
  // allocate our output vector
  NumericVector output = no_init(input.size());
  
  for (int i = 0; i < input.size(); i++) {
    output[i] = log(input[i]);
  }

  // return to R
  return output;
}"

sourceCpp(code=code)
  
x <- as.numeric(1:1E7)
identical(log(x), parallelLog(x))

microbenchmark(
  R = log(x),
  RcppParallel = parallelLog(x),
  times = 10
)
 
microbenchmark(
  Rcpp = Log_c(x),
  RcppParallel = parallelLog(x),
  times = 10
)

sourceCpp("cpp/inner-product.cpp")
n <- 1E6
lhs <- rnorm(n)
rhs <- rnorm(n)
all.equal(sum(lhs * rhs), parallelInnerProduct(lhs, rhs))

library(microbenchmark)
microbenchmark(
  R = sum(lhs * rhs),
  RcppParallel = parallelInnerProduct(lhs, rhs),
  times = 10
)
# demonstrate we really are using multiple cores
if (FALSE) {
  repeat parallelInnerProduct(lhs, rhs)
}