# Get the world polygon and extract FR
# Libraries
library(ggplot2)
library(dplyr)
library(maps)
library(geojsonio)
library(broom)
library(leaflet)
library(RColorBrewer)


# récupération des info geo départements
departements <- rgdal::readOGR("data/departements.geojson",
                               layer="TM_WORLD_BORDERS_SIMPL-0.3",)
# écupétrtiondes données de département
dep <-read.csv("data/departments.csv",sep = ',')
# jointure gauche
departements <-merge(departements,dep,by.x="code", by.y = "region_code", all= TRUE) 

# récupération des données de stage
data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
interships_counts_by_departments <- result %>%
  group_by(codeDepartement) %>%
  summarise(number_internships = n(),
            nb_heures = sum(as.numeric( Duree_calcul)))

# jointure entre les données de departement et les données de stage
departements <-merge(departements,interships_counts_by_departments,by.x="code", by.y = "codeDepartement", all= TRUE) 
departements


mybins <- c(1,10,20,50,100,10000,Inf)

# creation de la palette:
mypalette <- colorBin( palette="YlOrBr", domain=departements@data$number_internships, na.color="transparent", bins=mybins)

# Tooltips
mytext <- paste(
  "Département: ", departements$nom,"<br/>", 
  "Number of internships: ", round(departements$number_internships, 2), 
  "Cumul of Hours: ",round(departements$nb_heures, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

# carte Finale
m_dep <- leaflet(departements) %>% 
  addTiles()  %>% 
  setView(lng = 2.292551, lat = 48.858255, zoom = 5) %>%
  #setView( lat=10, lng=0 , zoom=2) %>%
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

m_dep 
