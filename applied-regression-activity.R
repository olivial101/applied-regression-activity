# Applied regression activity
# Construct LSOA-level dataset including
#   - London Crime data - 2022
#   - LSOA Indices of Deprivation - 2019
#   - LSOA Population Density - 2014

# Load packages
library(tidyverse)
library(readxl)
library(janitor)

# Load data
# Metropolitan crime data
file_list <- list.files("data/raw/dpu-crime-met-2022/", full.names = TRUE, recursive = TRUE)

crime_data_raw <- read_csv(file_list) |> clean_names()

# Construct crime measures
crime_data <- crime_data_raw |>
  filter(crime_type %in% c("Possession of weapons",
                           "Violence and sexual offences",
                           "Bicycle theft")) |>
  count(lsoa_code, crime_type, name = "crime_count") |>
  complete(lsoa_code = unique(crime_data_raw$lsoa_code),
           crime_type,
           fill = list(crime_count = 0)) |>
  mutate(crime_type = case_match(crime_type,
                                 "Bicycle theft"    ~ "bike_theft",
                                 "Possession of weapons"        ~ "weapon",
                                 "Violence and sexual offences" ~ "violence",
                                 .default                       = "ERROR"
  )) |>
  pivot_wider(names_from = crime_type, values_from = crime_count)

glimpse(crime_data)
save(crime_data, file = "data/derived/crime_data.RData")

# Deprivation

deprivation_raw <- read_csv("imd2019lsoa.csv") |> clean_names()

deprivation <- deprivation_raw |>
  filter(indices_of_deprivation == "h. Living Environment Deprivation Domain" &
           measurement == "Score") |>
  select(lsoa_code = feature_code, value)

save(deprivation, file = "data/derived/deprivation.RData")

density_raw <- read_excel("land-area-population-density-lsoa11-msoa11.xlsx", sheet = "LSOA11")

# Population density

pop_density <- density_raw |>
  clean_names() |>
  select(lsoa_code = lsoa11_code, density = people_per_sq_km)
save(pop_density, file = "data/derived/pop_density.RData")

files <- c("./data/derived/crime_data.RData", "./data/derived/deprivation.RData", "./data/derived/pop_density.RData")
lapply(files, load, .GlobalEnv)

# Pop density has all and only the LSOAs in London we want, so if we start with
# it we can just left join and it'll filter the others down.

analytical_data <- pop_density |>
  left_join(crime_data) |>
  left_join(deprivation) |>
  rename(deprivation = value)

save(analytical_data, file = "./data/analysis/analytical_data.RData")

# Validate
glimpse(analytical_data)
summary(analytical_data)
