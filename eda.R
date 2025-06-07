library(tidyverse)
library(forcats)
library(lubridate)
library(ggdark)

taxis = read_csv('taxis.csv')


# Tarifa total en relación a la distancia del viaje (sin adicionales)
ggplot(taxis)+
  geom_point(aes(x = trip_distance, 
                 y = fare_amount, 
                 color = PUBorough),
             size = 0.5,
             alpha = 0.5,
             na.rm = TRUE)+
  labs(title = 'Distribución del precio por viaje según la distancia',
       x = 'Distancia del viaje [millas]',
       y = 'Tarifa [U$S]',
       color = 'Barrio')+
  xlim(0, 25)+
  ylim(0, 120)+
  scale_color_manual(values = c('red', 'salmon', 'darkblue'))+
  theme_minimal()
# Podemos ver una relacion entre el aumento de la distancia
# y la tarifa correspondiente
# Aunque las relaciones varian mucho


# Promedio de precio por hora
costo_por_hora = taxis |> 
  group_by(hour(tpep_pickup_datetime)) |>
  summarise(costo = mean(fare_amount), cantidad = n()) |>
  arrange(desc(costo)) |>
  rename(hora = `hour(tpep_pickup_datetime)`)
# Entendiendo el costo por hora y la cantidad de viajes
ggplot(costo_por_hora)+
  geom_col(aes(x = hora, y = cantidad, fill = costo))+
  scale_fill_gradientn(colors = c('salmon', 'purple', 'blue'))+
  labs(title = 'Densidad de viajes por hora',
       x = 'Hora del día',
       y = 'Cantidad de viajes',
       fill = 'Costo promedio del viaje')
# Aislando la mediana del costo para cada hora
ggplot(costo_por_hora)+
  geom_col(aes(x = hora, y = costo), fill = 'blue', width = 0.75)+
  labs(title = 'Media de costo para cada hora del día',
       x = 'Hora del día',
       y = 'Precio [U$S]')+
  coord_cartesian(ylim = c(12, 15))


# El tipo de pago está relacionado a mayores propinas?
taxis |> 
  group_by(payment_type) |>
  summarise(mean(tip_amount))
# SI! pagando con tarjeta de crédito hay mucha más propina


# Cómo afecta la duración del viaje a la tarifa final?
ggplot(taxis, aes(x = trip_duration, 
                  y = fare_amount, 
                  color = trip_distance))+
  geom_point(na.rm = T, alpha = 0.5)+
  labs(title = 'Distribución del precio por viaje según la duración',
       x = 'Duración del viaje [minutos]',
       y = 'Tarifa [U$S]',
       color = 'Distancia [millas]')+
  scale_color_gradientn(colors = c('salmon', 'purple', 'blue', 'blue'))


# Hay una relación entre el día de la semana y la tarifa?
taxis |>
  group_by(weekdays(tpep_pickup_datetime)) |>
  summarise(median(fare_amount), mean(fare_amount))
# No hay una relación clara


# Hay "zonas premium" donde la tarifa valga más?
taxis |>
  group_by(PUZone) |>
  summarise(promedio_tarifa = median(fare_amount), viajes = n()) |>
  filter(viajes > 50) |>
  mutate(rango_tarifa = case_when(
      promedio_tarifa < 15.25 ~ "Mas baratas",
      promedio_tarifa >= 35 ~ "Mas caras")) |>
  filter(rango_tarifa %in% c('Mas baratas', 'Mas caras')) |>
  ggplot() +
  geom_col(aes(x = fct_reorder(PUZone, desc(promedio_tarifa)), 
               y = promedio_tarifa,
               fill = promedio_tarifa),
           na.rm = T, show.legend = F)+
  geom_vline(xintercept = 6.5, linetype = "dashed", size = 0.75) +
  scale_fill_gradientn(colors = c('salmon', 'purple', 'blue'))+
  coord_flip()+
  labs(title = 'Zonas más caras y más baratas para pedir un taxi',
       x = '',
       y = 'Tarifa promedio')


# Analizando precios en dias habiles vs fin de semana
taxis_dias = taxis |>
  group_by(wday(tpep_pickup_datetime, week_start = 1)) |>
  rename(weekday = `wday(tpep_pickup_datetime, week_start = 1)`) |>
  mutate(es_habil = ifelse(weekday > 6, 'Fin de semana', 'Dias hábiles')) |>
  ungroup()

costo_por_hora_dias = taxis_dias |> 
  group_by(hour(tpep_pickup_datetime), es_habil) |>
  summarise(costo = median(fare_amount), cantidad = n()) |>
  arrange(desc(costo)) |>
  rename(hora = `hour(tpep_pickup_datetime)`)

ggplot(costo_por_hora_dias)+
  geom_col(aes(x = hora, y = cantidad, fill = costo))+
  scale_fill_gradientn(colors = c("salmon", "purple", "blue"))+
  labs(title = 'Cantidad y costo de viajes por hora',
       x = 'Hora del día',
       y = 'Cantidad de viajes',
       fill = 'Costo promedio del viaje')+
  facet_wrap(~es_habil)


# Hay barrios con distribuciones mayores o menores de los costos?
ggplot(taxis)+
  geom_density(aes(x = fare_amount, fill = PUBorough), alpha = 0.75, color = 'black')+
  xlim(0, 100)+
  labs(title = 'Densidad de viajes según borough',
       x = 'Precio de la tarifa',
       y = 'Densidad',
       fill = 'Barrio')+
  scale_fill_manual(values = c('salmon', 'purple', 'blue'))
