# copy-pasting tables together in Excel proved more efficient than combining all sources in R, but the `conv_unit()` piece here works, for future reference

pacman::p_load(here, readxl, tidyverse, measurements)

waters.collection <- read_excel(here("data/2021_waters_collection.xlsx"))

# reformat lat and long fields and convert with measurements package
waters.collection.min <- waters.collection |>
  # filter coords recorded in degree - decimal minutes using relevant dates
  filter(Date < "2021-07-10") |>
  mutate(Lat.min = str_replace(Latitude, "'", " ")) |>
  mutate(Long.min = str_replace(Longitude, "'", " ")) |>
  mutate(Latitude = conv_unit(Lat.min, from = 'deg_dec_min', to = 'dec_deg')) |>
  mutate(Longitude = conv_unit(Long.min, from = 'deg_dec_min', to = 'dec_deg')) |>
  select(-Lat.min, -Long.min)


