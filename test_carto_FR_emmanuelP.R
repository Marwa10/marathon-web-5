# Get the world polygon and extract UK
# Libraries
library(ggplot2)
library(dplyr)
library(maps)
map <- map_data("france")# %>% filter(region=="FR")
ggplot(map, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill="lightgray", colour = "white")

