# chargement des librairies
library(dplyr)
library(leaflet)
library(rgdal)

# inspiration
#https://www.r-graph-gallery.com/183-choropleth-map-with-leaflet.html
# Download the shapefile. (note that I store it in a folder called DATA. You have to change that if needed.)
#download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="data/world_shape_file.zip")
# You now have it in your current working directory, have a look!

# Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
#system("unzip data/world_shape_file.zip")
#  -- >


# récupération des données de stage
data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
# récupération des données pays
pays = read.csv2("data/pays2020.csv",sep = ',')

# jointure entre les deux datas pour avoir le code ISO
result <- merge(data,pays,by.x="Paysetablissement", by.y="libcog", all= TRUE)

# regroupement 
head(result)
interships_counts_by_country <- result %>%
  group_by(codeiso3) %>%
  summarise(number_internships = n(),
            nb_heures = sum(as.numeric( Duree_calcul)))


#names(interships_counts_by_country)[names(interships_counts_by_country) == 'n'] <- 'number_internships'

#head(interships_counts_by_country)

# Lecture des données mondiale. 
world_spdf <- readOGR( 
  dsn= paste0(getwd(),"/data/world_shape_file/") , 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# jointure entre les données mondiales et les données de stage
world_spdf <-merge(world_spdf,interships_counts_by_country,by.x="ISO3", by.y = "codeiso3", all= TRUE) 






# creation de la palette:
mypalette <- colorBin( palette="YlOrBr", domain=world_spdf@data$number_internships, na.color="transparent", bins=mybins)

# Tooltips
mytext <- paste(
  "Country: ", world_spdf@data$NAME,"<br/>", 
  "Area: ", world_spdf@data$AREA, "<br/>", 
  "Number of internships: ", round(world_spdf@data$number_internships, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

# carte Finale
leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(number_internships), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white", 
    weight=0.3,
    label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~number_internships, opacity=0.9, title = "Number internships", position = "bottomleft" )

m  

###### fin du code à  intégrer ##########



##### début des tests persos #########
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


mypalette <- colorNumeric( palette="viridis", domain=world_spdf@data$number_internships, na.color="transparent")
mypalette(c(45,43))


m <- leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(number_internships), stroke=FALSE )

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
