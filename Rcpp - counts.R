library(Rcpp)
library(dplyr)
library(tidyr)
library(microbenchmark)

n <- 1e5

df <- data_frame(Reported = rnorm(n, 1500, 100),
                 Closed = Reported+rnorm(n, 1500, 100))



count <- df %>%
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

sourceCpp("countday.cpp")

t1 <- countdays_m(as.matrix(df)) 
t2 <- countdays(df)
identical(t1,t2)