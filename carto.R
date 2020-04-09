# Changelog
# emp:  mise en 

# todo :  enlever les données de la france ou les minimiser

# chargement des librairies
library(dplyr)
library(leaflet)
library(rgdal)

library(RColorBrewer)

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

interships_counts_by_country <- result %>%
  group_by(codeiso3) %>%
  summarise(number_internships = n(),
            nb_heures = sum(as.numeric( Duree_calcul)),
            nb_etab = n_distinct(Numsiret))


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




mybins <- c(1,10,20,50,100,10000,Inf)

# creation de la palette:
mypalette <- colorBin( palette="YlOrBr", domain=world_spdf@data$number_internships, na.color="transparent", bins=mybins)

# Tooltips
mytext <- paste(
  "Pays: ", world_spdf@data$NAME,"<br/>", 
  "Nombre de stages: ", round(world_spdf@data$number_internships, 2), "<br/>", 
  "Cumul des heures: ",round(world_spdf@data$nb_heures, 2), "<br/>", 
  "Nombre d'établissements d'accueil: ",world_spdf@data$nb_etab,"<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

# carte Finale
m <- leaflet(world_spdf) %>% 
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
  addLegend( pal=mypalette, values=~number_internships, opacity=0.9, title = "Nombre de stages", position = "bottomleft" )

m  

###### fin du code à  intégrer ##########

