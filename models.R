library(tidyverse)

taxis = read_csv('taxis.csv')

mod0 = lm(formula = total_amount ~ trip_distance, data = taxis)
summary(mod0)

mod1 = lm(formula = total_amount ~ trip_distance + trip_duration, data = taxis)
summary(mod1)

taxis = taxis |> mutate(hour = as.integer(hour(tpep_pickup_datetime)))
mod2 = lm(formula = total_amount ~ trip_distance * factor(hour), data = taxis)
summary(mod2)

mod3 = lm(formula = total_amount ~ trip_distance + PUBorough, data = taxis)
summary(mod3)

anova(mod0, mod1, mod2)
