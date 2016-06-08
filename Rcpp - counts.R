library(Rcpp)
library(dplyr)
library(tidyr)
library(microbenchmark)

n <- 1e4

df <- data_frame(Reported = rnorm(n, 1500, 100),
                 Closed = Reported+rnorm(n, 1500, 100))

sourceCpp("cpp/countday_11.cpp")
sourceCpp("cpp/countday_std.cpp")

count.r <- df %>%
  mutate(start = ceiling(Reported),
         end = floor(Closed),
         claim = row_number()) %>%
  select(start, end, claim) %>%
  gather(period, value, -claim) %>%
  group_by(claim) %>%
  arrange(claim) %>%
  expand(claim, days=min(value):max(value)) %>%
  mutate(count = 1) %>%
  group_by(days) %>%
  summarise(count=sum(count))

count.rcpp <- countdays(df)
count.rcpp_m <- countdays_m(as.matrix(df))
count.rcpp_std <- countdays_std(df)

identical(count.rcpp,count.rcpp_m)
identical(count.rcpp %>% arrange(days),count.rcpp_std)

microbenchmark(countdays(df), 
               countdays_m(as.matrix(df)),
               countdays_std(df))
