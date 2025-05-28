library(tidyverse)
library(forcats)

taxis = read_csv('taxis.csv')

taxis = drop_na(taxis)

# Tarifa total en relación a la distancia del viaje
ggplot(taxis)+
  geom_point(aes(x = trip_distance, 
                 y = total_amount, 
                 color = PUBorough),
             alpha = 0.5,
             na.rm = TRUE)+
  labs(title = 'Distribución del precio por viaje según la distancia',
       x = 'Distancia del viaje [millas]',
       y = 'Tarifa [U$S]',
       color = 'Zona de salida')+
  ylim(0, 300)+
  xlim(0, 50)+
  theme_minimal()
# Podemos ver una relacion entre el aumento de la distancia
# y la tarifa correspondiente
# Aunque las relaciones varian mucho2

# Promedio de precio por hora
costo_por_hora = taxis |> 
  group_by(hour(tpep_pickup_datetime)) |>
  summarise(costo = median(total_amount), cantidad = n()) |>
  arrange(desc(costo)) |>
  rename(hora = `hour(tpep_pickup_datetime)`)

# Entendiendo el costo por hora y la cantidad de viajes
ggplot(costo_por_hora)+
  geom_col(aes(x = hora, y = cantidad, fill = costo))+
  scale_fill_gradientn(colors = c("darkgreen", "yellow", "red"))+
  labs(title = 'Densidad de viajes por hora',
       x = 'Hora del día',
       y = 'Cantidad de viajes',
       fill = 'Costo promedio del viaje')

# El tipo de pago está relacionado a mayores propinas?
taxis |> 
  group_by(payment_type) |>
  summarise(mean(tip_amount))
# SI! pagando con tarjeta de crédito hay mucha más propina

# Qué tipos de viaje entre zonas son más caros? Hay alguna relación?
taxis |>
  group_by(PUBorough, DOBorough) |>
  summarise(tarifa_promedio = median(total_amount, na.rm = T), viajes = n()) |>
  arrange(desc(tarifa_promedio)) |>
  filter(viajes > 20) |>
  ggplot(aes(x = PUBorough, y = DOBorough, fill = tarifa_promedio)) +
  geom_tile()+
  scale_fill_gradientn(colors = c("darkgreen", "yellow", "red"))+
  labs(title = "Tarifa mediana por par de zonas (+20 viajes)", 
       x = "Origen", 
       y = "Destino", 
       fill = "Tarifa [U$S]") +
  theme_minimal()

# Cómo afecta la duración del viaje a la tarifa final?
ggplot(taxis, aes(x = trip_duration, 
                  y = total_amount, 
                  color = trip_distance))+
  geom_point(na.rm = T, alpha = 0.5)+
  xlim(0, 1750)
# ...no hay una relación clara

# Hay una relación entre el día de la semana y la tarifa?
taxis |>
  group_by(weekdays(tpep_pickup_datetime)) |>
  summarise(median(total_amount), mean(total_amount))
# No hay una relación clara

# Hay una relación entre el número de pasajeros y el precio?
taxis |>
  group_by(passenger_count) |>
  summarise(median(total_amount), mean(total_amount)) |>
  ggplot(aes(x = passenger_count, y = `median(total_amount)`))+
  geom_point()
# Tampoco podríamos decir que hay relación

# Hay "zonas premium" donde la tarifa valga más?
taxis |>
  group_by(PUZone) |>
  summarise(promedio_tarifa = median(total_amount), viajes = n()) |>
  filter(viajes > 50) |>
  mutate(rango_tarifa = case_when(
      promedio_tarifa < 17 ~ "Mas baratas",
      promedio_tarifa >= 80 ~ "Mas caras")) |>
  filter(rango_tarifa %in% c('Mas baratas', 'Mas caras')) |>
  ggplot() +
  geom_col(aes(x = fct_reorder(PUZone, desc(promedio_tarifa)), 
               y = promedio_tarifa,
               fill = promedio_tarifa),
           na.rm = T, show.legend = F)+
  scale_fill_gradientn(colors = c('orange', "red"))+
  coord_flip()+
  labs(title = 'Zonas más caras y más baratas para pedir un taxi',
       x = '',
       y = 'Tarifa promedio')

# La duración del viaje afecta a la tarifa según la distancia?
taxis |> 
  filter(trip_duration < 120 & trip_duration > 0) |>
  ggplot()+
  geom_point(aes(x = trip_distance, 
                 y = total_amount, 
                 color = trip_duration),
             alpha = 0.5,
             na.rm = TRUE)+
  scale_color_gradientn(colors = c('orange', 'red', "purple"))+
  labs(title = 'Distribución del precio por viaje según la distancia',
       x = 'Distancia del viaje [millas]',
       y = 'Tarifa [U$S]',
       color = 'Duración del viaje')+
  ylim(0, 300)+
  xlim(0, 50)+
  theme_minimal()
# Se logra apreciar una relación mínima
