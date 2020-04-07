library(sf)
library(tidyverse)
library(leaflet)
library(rgdal)
shp_departement= "data/departements-20140306-100m.shp"
#leaflet() %>% 
#  fitBounds(-20,65,20,40) %>% 
#  addTiles() %>%
#  addProviderTiles(providers$CartoDB.Positron)
#departements <- shapefile(shp_departement)
leaflet(data = departements) %>% addTiles() %>% addProviderTiles(providers$OpenStreetMap) %>% 
  addPolygons(fill = FALSE, stroke = TRUE, color = "#03F") %>% addLegend("bottomright", colors = "#03F", labels = "deparetemtns")

#states <- readOGR("data/departements-20140306-100m.shp",
#                  layer = "cb_2013_us_state_20m", GDAL1_integer64_policy = TRUE)
#France <- st_read(here::here("data","departements-20140306-100m.shp"), quiet=TRUE) 
#head(states)

