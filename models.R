library(tidyverse)

taxis = read_csv('taxis.csv')
taxis = taxis |> mutate(hour = as.integer(hour(tpep_pickup_datetime)))

mod0 = lm(formula = total_amount ~ trip_distance, data = taxis)
summary(mod0)

mod1 = lm(formula = total_amount ~ trip_distance + trip_duration, data = taxis)
summary(mod1)

ggplot(taxis)+
  geom_col(aes(x = hour, y = mean(total_amount)))
mod2 = lm(formula = total_amount ~ trip_distance + factor(hour), data = taxis)
summary(mod2)

mod2_2 = lm(formula = total_amount ~ trip_distance + poly(hour, 3), data = taxis)
summary(mod2_2)

mod3 = lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough, data = taxis)
summary(mod3)

mod4 = lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough + hour, data = taxis)
summary(mod4)

mod5 = lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough + factor(hour), data = taxis)
summary(mod5)

anova(mod1, mod3, mod5)
