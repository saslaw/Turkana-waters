
pacman::p_load(here, readxl, tidyverse, measurements)

waters.collection <- read_excel(here("2021waters.xlsx"))

# reformat lat and long fields and convert with measurements package  
waters.collection <- waters.collection %>% 
  mutate(Lat.min = str_replace(Latitude, "'", " ")) %>%
  mutate(Long.min = str_replace(Longitude, "'", " ")) %>%
  mutate(Lat.deg = round(as.numeric(conv_unit(Lat.min, from = 'deg_dec_min', to = 'dec_deg')), 5)) %>%
  mutate(Long.deg = round(as.numeric(conv_unit(Long.min, from = 'deg_dec_min', to = 'dec_deg')), 5)) %>%
  select(-Lat.min, -Long.min)
  
          
