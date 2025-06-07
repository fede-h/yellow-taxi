library(arrow)
library(tidyverse)

taxis = read_parquet("yellow_tripdata_2025-03.parquet")

# Mapeos de variables con ID:
#   Compañia (VendorID)
#   Tipo de tarifa (RatecodeID)
#   Tipo de pago (payment_type)
#   Ubicacion de arribo y llegada, por zona (PULocation y DOLoaction)
# Source: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf

vendor_mapping <- data.frame(
  VendorID = c(1, 2, 6, 7),
  Vendor = c(
    "Creative Mobile Technologies, LLC",
    "Curb Mobility, LLC",
    "Myle Technologies Inc",
    "Helix"
  )
)

fare_mapping <- data.frame(
  RatecodeID = c(1, 2, 3, 4, 5, 6, 99),
  RatecodeDescription = c(
    "Standard rate",
    "JFK",
    "Newark",
    "Nassau or Westchester",
    "Negotiated fare",
    "Group ride",
    NA
  )
)

payment_mapping <- data.frame(
  payment_type = c(0, 1, 2, 3, 4, 5, 6),
  payment_description = c(
    "Flex Fare trip",
    "Credit card",
    "Cash",
    "No charge",
    "Dispute",
    NA,
    "Voided trip"
  )
)

# Left join y elimino NA para todos los mapeos
# Despues elimino las columnas de dirección

taxis = left_join(taxis, vendor_mapping, by = 'VendorID')
taxis = left_join(taxis, fare_mapping, by = 'RatecodeID')
taxis = left_join(taxis, payment_mapping, by = 'payment_type')
taxis = taxis |> select(-VendorID, -RatecodeID, -payment_type)
taxis = taxis |> rename(payment_type = payment_description)

# Referencias de https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
# Todas las zonas mapeadas, elimino la zona de servicio (siempre es Yellow)

taxi_zones = read_csv('taxi_zone_lookup.csv')
taxi_zones = taxi_zones |> select(-service_zone)
taxi_zones = taxi_zones |>
  mutate(Borough = replace(Borough, Borough %in% c('N/A', 'Unknown'), NA)) |>
  mutate(Zone = replace(Zone, Zone %in% c('N/A', 'Unknown'), NA))

taxis = left_join(taxis, taxi_zones, by = join_by('PULocationID' == 'LocationID'))
taxis = left_join(taxis, taxi_zones, by = join_by('DOLocationID' == 'LocationID'))
# Organizando las ubicaciones y limpio los indices
taxis = taxis |> rename(PUBorough = Borough.x,
                        PUZone = Zone.x,
                        DOBorough = Borough.y,
                        DOZone = Zone.y)
taxis = taxis |> select(-PULocationID, -DOLocationID)

# Calculando la duración del viaje restando la llegada
# Limpieza de viajes de duración 0 mins
taxis = taxis |>
  mutate(trip_duration = as.integer(difftime(
    tpep_dropoff_datetime, 
    tpep_pickup_datetime, 
    units = "mins")))
taxis = taxis |> filter(trip_duration > 0)

# Filtro VIAJES INTRAZONALES
# y que no sean hasta aeropuertos (U$S70 fijos)

taxis = taxis |>
  filter(0 < trip_distance, trip_distance < 40,
         0 < trip_duration, trip_duration < 120,
         total_amount > 0, total_amount < 200,
         passenger_count > 0,
         PUBorough %in% c('Manhattan', 'Queens', 'Brooklyn'),
         PUBorough == DOBorough,
         !(str_detect(PUZone, 'Airport') | str_detect(DOZone, 'Airport')))


# Sampleo 400000 observaciones 
taxis = taxis  |> 
  drop_na() |>
  sample_n(400000)

# Guardado a .csv
write_csv(taxis, 'taxis.csv')
