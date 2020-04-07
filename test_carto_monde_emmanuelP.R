library(sf)
library(tidyverse)
library(leaflet)
library(rgdal)
library(raster)
# inspiration
#https://www.r-graph-gallery.com/183-choropleth-map-with-leaflet.html
data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
head(data)
pays = read.csv2("data/pays2020.csv",sep = ',')
#pays$Paysetablissement <-pays$libcog
head(pays)
data$Paysetablissement
result <- merge(data,pays,by.x="Paysetablissement", by.y="libcog", all= TRUE)
head(result)
# Download the shapefile. (note that I store it in a folder called DATA. You have to change that if needed.)
#download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="data/world_shape_file.zip")
# You now have it in your current working directory, have a look!

# Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
#system("unzip data/world_shape_file.zip")
#  -- >

head(result)
interships_counts_by_country <- result %>%
  group_by(codeiso3) %>%
  tally

names(interships_counts_by_country)[names(interships_counts_by_country) == 'n'] <- 'number_internships'

head(interships_counts_by_country)

# Read this shape file with the rgdal library. 
library(rgdal)
world_spdf <- readOGR( 
  dsn= paste0(getwd(),"/data/world_shape_file/") , 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Clean the data object
library(dplyr)
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)
result_world <-merge(world_spdf,interships_counts_by_country,by.x="ISO3", by.y = "codeiso3", all= TRUE) 
head(result_world)
#result_world$ISO2
#result_world_filtered<- dplyr::filter(result_world,ISO2=='FR')
#ad(result_world_filtered)

# Create a color palette for the map:
mypalette <- colorNumeric( palette="viridis", domain=result_world@data$number_internships, na.color="transparent")
mypalette(c(45,43))

# Basic choropleth with leaflet?
m <- leaflet(result_world) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(number_internships), stroke=FALSE )

m



# load ggplot2
library(ggplot2)

# Distribution of the population per country?
result_world@data %>% 
  ggplot( aes(x=as.numeric(number_internships))) + 
  geom_histogram(bins=20, fill='#69b3a2', color='white') +
  xlab("Number of internships") + 
  theme_bw()

# Color by quantile
m <- leaflet(result_world)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorQuantile("YlOrRd", number_internships)(number_internships) )
m

# Numeric palette
m <- leaflet(result_world)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorNumeric("YlOrRd", number_internships)(number_internships) )
m

# Bin
m <- leaflet(result_world)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorBin("YlOrRd", number_internships)(number_internships) )
m


#shp_departement= ".data/departements-20140306-100m.shp"
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

llanos <- shapefile("/Users/epellegrin/git/MIASHS/marathon_du_web/marathon-web-5/data/departements-20140306-100m.shp")
