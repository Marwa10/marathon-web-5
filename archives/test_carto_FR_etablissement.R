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
  
  villes_gps <-read.csv("data/cities.csv",sep = ',') %>%
    select(-'id',-department_code,-insee_code,-slug)%>%
    rename(codePostalEtablissement = zip_code,
           nomVille=name,
           lat = gps_lat,
           lon =gps_lng)


# # récupération des info INSEE

data_insee  <-read.csv2("data/siret_insee_all_etab.csv", stringsAsFactors = FALSE) 


# récupération des données de stage
data_stage = read.csv2("data/donnees_c2.csv", stringsAsFactors = FALSE) %>%
  rename(siret=Numsiret)

data_stage <-merge(data_stage,data_insee ,by="siret", all= TRUE,duplicateGeoms = TRUE) 

data_stage <-merge(data_stage,villes_gps,by="codePostalEtablissement", all= TRUE,duplicateGeoms = TRUE) 


interships_counts_by_CP <- data_stage %>%
  group_by(codePostalEtablissement,nomVille,lat,lon) %>%
  summarise(number_internships = n(),
            nb_heures = sum(as.numeric( Duree_calcul)),
            nb_etab = n_distinct(siret) )
# Create a color palette with handmade bins.

mybins <- c(1,5,10,20,30,Inf)
mypalette <- colorBin( palette="YlOrBr", domain=interships_counts_by_CP$nb_etab, 
                       na.color="transparent", bins=mybins)

# Tooltips
mytext <- paste(
  "Ville: ", interships_counts_by_CP$nomVille,"<br/>", 
  "Nombre d'établissements d'accueil: ",interships_counts_by_CP$nb_etab,"<br/>", 
  "Nombre de stages: ", round(interships_counts_by_CP$number_internships, 2), "<br/>", 
  "Cumul des heures: ",round(interships_counts_by_CP$nb_heures, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

# carte Finale
m_dep <- leaflet(interships_counts_by_CP) %>% 
  addTiles()  %>% 
  setView(lng = 2.292551, lat = 48.858255, zoom = 5) %>%
  addCircleMarkers(~lon, ~lat, 
                   fillColor = ~mypalette(number_internships), 
                   fillOpacity = 0.7, color="white", 
                   radius=3*interships_counts_by_CP$nb_etab, 
                   stroke=FALSE,
                   label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", 
                                                             padding = "3px 8px"), 
                                                textsize = "13px", direction = "auto")
  ) %>%
  addLegend( pal=mypalette, values=~number_internships, opacity=0.9, title = "Nombre de Stages", position = "bottomleft" )

m_dep 

####################### fin du code à  intégrer ############
