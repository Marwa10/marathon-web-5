# Get the world polygon and extract FR
# Libraries
library(ggplot2)
library(dplyr)
library(maps)
library(geojsonio)
library(broom)
library(leaflet)
library(RColorBrewer)
library(rgdal)


# récupération des info geo départements
departements_carto_FR <- rgdal::readOGR("data/departements.geojson"
                                        #layer="TM_WORLD_BORDERS_SIMPL-0.3",
                                        #GDAL1_integer64_policy = TRUE
)
# écupétrtiondes données de département
dep <-read.csv("data/departments.csv",sep = ',') %>%
  select(-code,-slug)%>%
  rename(code = region_code)
# jointure gauche
departements_carto_FR <-merge(departements_carto_FR,dep,by="code",  all= TRUE,duplicateGeoms = TRUE)


# récupération des données de stage
data_stage_carto_FR = read.csv2("data/donnees_c2.csv", stringsAsFactors = FALSE) 
interships_counts_by_departments <- data_stage_carto_FR %>%
  group_by(codeDepartement) %>%
  summarise(number_internships = n(),
            nb_heures = sum(as.numeric( Duree_calcul)),
            nb_etab = n_distinct(Numsiret) )%>%
  rename(code = codeDepartement)

# jointure entre les données de departement et les données de stage
departements_carto_FR <-merge(departements_carto_FR,interships_counts_by_departments,
                              by="code", all= TRUE,duplicateGeoms = TRUE) 

#departements_carto_FR@data$number_internship

mybins <- c(1,10,20,50,100,10000,Inf)

# creation de la palette:
mypalette <- colorBin( palette="YlOrBr", domain=departements_carto_FR@data$number_internships, na.color="transparent", bins=mybins)

# Tooltips
mytext <- paste(
  "Département: ", departements_carto_FR$code,' - ',departements_carto_FR$nom,"<br/>", 
  "Nombre d'établissements d'accueil: ",departements_carto_FR$nb_etab,"<br/>", 
  "Nombre de stages: ", round(departements_carto_FR$number_internships, 2), "<br/>", 
  "Cumul des heures: ",round(departements_carto_FR$nb_heures, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

# carte Finale
m_dep <- leaflet(departements_carto_FR) %>% 
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
  addLegend( pal=mypalette, values=~number_internships, opacity=0.9, title = "Nombre de Stages", position = "bottomleft" )

m_dep 

####################### fin du code à  intégrer ############
