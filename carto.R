library(dplyr)
library(leaflet)
library(rgdal)
library(RColorBrewer)



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




mybins <- c(0,10,20,50,100,10000,Inf)

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
map = leaflet(world_spdf) %>% 
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

map
