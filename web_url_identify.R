#setwd("/Users/priscille/Desktop/")

# Load packages
library(rvest)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)
library(XML)
library(tm)
library(httr)




#### première partie ######
###### objectif:  récuperer les sites webs des etablissement



# récupération des données de stage
data_siret_scrapping = read.csv2("data/donnees_ufr.csv", stringsAsFactors = FALSE)
# suppression des siret vides
#data_siret <- subset( data, "Numsiret" != "NA")
data_siret_scrapping %>%
  drop_na(Numsiret)

# regrioupement des siret
data_siret_scrapping<- data_siret_scrapping %>%
  mutate(Nometablissement = trimws(Nometablissement))%>%
  group_by(Numsiret,Nometablissement,.drop = TRUE) %>%
  summarise(nb_stages = n(),
            nb_heures = sum(as.numeric( Duree_calcul))
  )%>%
  arrange(desc(nb_stages))%>%
  mutate(url="",keywords="")%>%
  top_n(20)

write.csv2(data_siret_scrapping,"data/etab_keywords.csv", row.names = TRUE)
