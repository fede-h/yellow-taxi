library(tidyverse)
library(modelr)
library(ggdark)

taxis = read_csv('taxis.csv')

# Modelo más basico tomando la distancia
mod0 = lm(formula = fare_amount ~ trip_distance, data = taxis)
summary(mod0)
# Vemos que calcula +4,75 dólares por cada milla


# Agregando la variable duracion vemos como el modelo tiene menos error
# La inclusión de la variable tiempo complementa al modelo original
mod1 = lm(formula = fare_amount ~ trip_distance + trip_duration, data = taxis)
summary(mod1)
# +3 dólares por cada milla adicional
# +1 dólar por cada 2 minutos de viaje


# Agregamos la variable categórica PUBorough para mostrar la diferencia
# entre los precios para cada barrio que se vió gráficamente
mod2 = lm(formula = fare_amount ~ trip_distance + trip_duration + PUBorough, data = taxis)
summary(mod2)
# Tomando Brooklyn como referencia
# un viaje en Manhattan es 3 dólares más caro en promedio
# y uno en Queens es 5,5 dólares más caro


# Se agrega la hora del viaje para incluir la variable en el modelo
taxis = taxis |> mutate(hour = as.integer(hour(tpep_pickup_datetime)))
# Con los gráficos del EDA pudimos corroborar
# que hay horas pico más caras que el resto del día
mod3 = lm(formula = fare_amount 
          ~ trip_distance 
          + trip_duration 
          + PUBorough 
          + factor(hour), 
          data = taxis)
summary(mod3)
# 24 parámetros más
# un viaje a las 17hs es 1,13 dólares más caro
# que un viaje a las 00hs (referencia)

anova(mod0, mod1, mod2, mod3)
# El P valor es < 2.2e-16 para todos los modelos 
# más complejos que el anterior

# Con el gráfico de los residuos no vemos patrones extraños
# que nos sugieran usar otro tipo de modelo
# solo llama la atención los residuos elevados cerca de 0
taxis_res = taxis |> 
  add_predictions(mod3) |>
  add_residuals(mod3) 

ggplot(taxis_res, aes(x = pred, y = resid))+
  geom_point(alpha = 0.3, color = 'blue')+
  geom_hline(yintercept = 0)+
  geom_hline(yintercept = 25)

# Cómo podemos explicar los residuos divergentes cerca de 0?
residuos = taxis |>
  add_predictions(mod3) |>
  add_residuals(mod3) |>
  filter(resid > 25)
# En 25 se separan los residuos anómalos

# Vemos que hay muchos valores de 70 y 85 dolares
# para el precio de la tarifa (sin contar adicionales)
ggplot(residuos)+
  geom_histogram(aes(x = fare_amount), color = 'black', fill = 'grey')+
  geom_vline(xintercept = 70, color = 'red')+
  geom_vline(xintercept = 85, color = 'red')

ggplot(residuos)+
  geom_point(aes(x = tip_amount, y = fare_amount), color = 'black')

residuos |>
  group_by(PUZone) |>
  summarise(n()) |>
  arrange(desc(`n()`))
# Los residuos elevados se deben a los viajes
# desde o hasta los aeropuertos
# se procede a filtrar los viajes correspondientes
