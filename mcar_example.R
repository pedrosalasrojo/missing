
#         Date: 28/06/2021
#         Dataset: NiDS 5
#         Project: Example of corruption and simple imputation with MCAR

rm(list = ls(all.names = TRUE)) 
library(tidyverse)
library(mice)         # Contains function "ampute"
library(radiant.data) # Contains weighted.sd 
library(dineq)        # Contains gini.wtd

results <- NA
com <- NA
reps <- 5                             # set number of iterations
sequence <- c(5, 10, 25, 40, 50)      # missing shares
pat_emp <- t(matrix(c(0, rep(1,42)))) # define the pattern (0=missing, 1=complete)

# Get data ----

nids <- read_csv("your_path/nids.csv", 
                 show_col_types = FALSE)

# for each value in "sequence"

for (h in sequence) {

  # for 1 to X replications
  
  for (i in 1:reps) {

    print(paste0("MCAR, share: ", h,", iteration: ",i))
    
    set.seed(i)
    
    # Corrupt the data with the proportion and mechanism desired. In this case, MCAR
    
    dat <- ampute(data = nids, prop=h/100, mech = "MCAR", patterns = pat_emp)
    dat <- dat$amp
    
    # Single parametric imputation 
    
    model <- lm(log(fwag) ~ male + coloured + asian_indian + white +
                  best_age_yrs + agesq + tradeunion + schooling + 
                  schoolingsq + cert_nomat + dip_nomat + cert_mat + dip_mat+
                  bachelors + bach_dip + honours + married + homerooms +
                  homeroomssq + hhintmonth_3 + hhintmonth_4 + hhintmonth_5 + hhintmonth_6 +
                  hhintmonth_7 + hhintmonth_8 + hhintmonth_9 + hhintmonth_10 + hhintmonth_11 +
                  hhintmonth_12 + province_2 + province_3 + province_4 + province_5 + province_6 +
                  province_7 + province_8 + province_9 + geo2011_2 + geo2011_3, 
                data=dat, na.action = na.exclude)
    
    dat$pred <- predict(model, newdata = dat, type = "response")
    
    #Arrange the prediction
    
    dat$res  <- resid(model)
    dat$fwag <- ifelse(is.na(dat$fwag), 
                       exp(dat$pred + (weighted.sd(dat$res, dat$pesos)^2)/2), 
                       dat$fwag)
    
    #Get results
    
    tab <- dat %>%
      select(ident, fwag, original, everything()) %>%
      summarise(obs_mis = (1-(h/100))*nrow(dat),
                perc_mis = h,
                gini_bias = 100*round(gini.wtd(fwag, pesos) - gini.wtd(original, pesos), 2))
    
    com <- rbind(com, tab)
    
  }
  
  mean <- com %>% 
    summarise_all(funs(mean), na.rm = TRUE)
  
  results <- na.omit(rbind(results, mean))
  
  com <- NA
  
}

print(results)
