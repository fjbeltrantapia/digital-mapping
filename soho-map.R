rm(list=ls()) # Clear de "Global Environment"
setwd("~/Library/CloudStorage/OneDrive-NTNU/course-websites/digital-mapping")

# Create the Soho map
library(tidyverse)
library(sf)
library(tmap)
tmap_mode("plot")  # Forces static plotting, suitable for PDF
deaths <- read_sf("data/snow1/deaths_nd_by_house.shp") |> 
  st_transform(crs = 3857)
pump_bs <- read_sf("data/snow6/pumps.shp") |> 
  filter(name=="Broad St Pump") |> 
  st_transform(crs = 3857)
pumps <- read_sf("data/snow6/pumps.shp") |>
  st_transform(crs = 3857)

soho <- tm_shape(deaths) + 
  tm_symbols(col = "grey80", fill = "grey80",
             col_alpha = 0, fill_alpha = 0.5,
             size = 0.3) +
  # tm_tiles("OpenStreetMap") +
  tm_shape(deaths) + 
  tm_dots(fill = "red", col = "red",
          size = "deaths_r",
          col_alpha = 0.5, fill_alpha = 0.5,
          size.scale = tm_scale_intervals(
            breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)),
          size.legend = tm_legend(
            title = "Deaths (residents)",
            frame = FALSE,
            orientation = "portrait")) +
  tm_shape(pump_bs) + 
  tm_symbols(fill = "darkblue", size = 0.8, 
             shape = 18, fill_alpha = 0.6) +
  tm_shape(pumps) + 
  tm_symbols(fill = "blue", size = 0.5, 
             shape = 18, fill_alpha = 0.6) +  
  tm_add_legend(fill = "darkblue", size = 0.8, 
                shape = 18, fill_alpha = 0.6, labels = "Broad Street Pump") +
  tm_add_legend(fill = "blue", size = 0.5, 
                shape = 18, fill_alpha = 0.6, labels = "Other pumps")

tmap_save(soho, "images/soho.tiff",
  width    = 7,
  height   = 5)