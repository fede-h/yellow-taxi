library(tidyverse)

taxis = read_csv('taxis.csv')
taxis = drop_na(taxis)

mod0 = lm(formula = total_amount ~ trip_distance, data = taxis)
summary(mod0)

mod1 = lm(formula = total_amount ~ trip_distance + trip_duration, data = taxis)
summary(mod1)

mod2 = lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough, data = taxis)
summary(mod2)

anova(mod0, mod1, mod2)
