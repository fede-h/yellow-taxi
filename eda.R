library(tidyverse)
library(forcats)
library(lubridate)
library(ggdark)

taxis = read_csv('taxis.csv')


# Tarifa total en relación a la distancia del viaje
ggplot(taxis)+
  geom_point(aes(x = trip_distance, 
                 y = total_amount, 
                 color = PUBorough),
             size = 0.5,
             alpha = 0.5,
             na.rm = TRUE)+
  labs(title = 'Distribución del precio por viaje según la distancia',
       x = 'Distancia del viaje [millas]',
       y = 'Tarifa [U$S]',
       color = 'Barrio')+
  xlim(0, 30)+
  ylim(0, 150)+
  scale_color_manual(values = c('#1e96fc', 'yellow', '#df00ff'))+
  theme_minimal()+
  dark_mode()
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
  scale_fill_gradientn(colors = c('white', 'yellow','darkorange'))+
  labs(title = 'Densidad de viajes por hora',
       x = 'Hora del día',
       y = 'Cantidad de viajes',
       fill = 'Costo promedio del viaje')+
  dark_mode()


# El tipo de pago está relacionado a mayores propinas?
taxis |> 
  group_by(payment_type) |>
  summarise(mean(tip_amount))
# SI! pagando con tarjeta de crédito hay mucha más propina


# Cómo afecta la duración del viaje a la tarifa final?
ggplot(taxis, aes(x = trip_duration, 
                  y = total_amount, 
                  color = trip_distance))+
  geom_point(na.rm = T, alpha = 0.5)+
  labs(title = 'Distribución del precio por viaje según la duración',
       x = 'Duración del viaje [minutos]',
       y = 'Tarifa [U$S]',
       color = 'Distancia [millas]')+
  scale_color_gradientn(colors = c('white', "yellow", 'orange', "darkorange", 'darkorange'))+
  dark_mode()


# Hay una relación entre el día de la semana y la tarifa?
taxis |>
  group_by(weekdays(tpep_pickup_datetime)) |>
  summarise(median(total_amount), mean(total_amount))
# No hay una relación clara


# Hay "zonas premium" donde la tarifa valga más?
taxis |>
  group_by(PUZone) |>
  summarise(promedio_tarifa = median(total_amount), viajes = n()) |>
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
  scale_fill_gradientn(colors = c('yellow', 'orange', 'darkorange'))+
  coord_flip()+
  labs(title = 'Zonas más caras y más baratas para pedir un taxi',
       x = '',
       y = 'Tarifa promedio')+
  dark_mode()


# Analizando precios en dias habiles vs fin de semana
taxis_dias = taxis |>
  group_by(wday(tpep_pickup_datetime, week_start = 1)) |>
  rename(weekday = `wday(tpep_pickup_datetime, week_start = 1)`) |>
  mutate(es_habil = ifelse(weekday > 6, 'Fin de semana', 'Dias hábiles')) |>
  ungroup()

costo_por_hora_dias = taxis_dias |> 
  group_by(hour(tpep_pickup_datetime), es_habil) |>
  summarise(costo = median(total_amount), cantidad = n()) |>
  arrange(desc(costo)) |>
  rename(hora = `hour(tpep_pickup_datetime)`)

ggplot(costo_por_hora_dias)+
  geom_col(aes(x = hora, y = cantidad, fill = costo))+
  scale_fill_gradientn(colors = c("lightyellow", "yellow", "darkorange"))+
  labs(title = 'Cantidad y costo de viajes por hora',
       x = 'Hora del día',
       y = 'Cantidad de viajes',
       fill = 'Costo promedio del viaje')+
  facet_wrap(~es_habil)+
  dark_mode()

# Hay barrios con distribuciones mayores o menores de los costos?
ggplot(taxis)+
  geom_density(aes(x = total_amount, fill = PUBorough), alpha = 0.75, color = 'black')+
  xlim(0, 100)+
  labs(title = 'Densidad de precios según borough',
       x = 'Precio de la tarifa',
       y = 'Densidad',
       fill = 'Barrio')+
  scale_fill_manual(values = c('#1e96fc', 'yellow', '#df00ff'))+
  dark_mode()
