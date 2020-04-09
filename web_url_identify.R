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
library(tidyr)


#https://api.duckduckgo.com/?q=<your search string>&format=json&pretty=1&no_html=1&skip_disambig=1

#### première partie ######
###### objectif:  récuperer les sites webs des etablissement

url_search <-"https://api.duckduckgo.com"
path_search <-""

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
for (row in 1:2#nrows(data_siret_scrapping)
     ){
  nom <- data_siret_scrapping[row, "Nometablissement"]
  resut_search<- httr::GET(url = url_search,query = list(q=nom,format="json"#,pretty=1,no_html=1,skip_disambig=1)
                                                         ),      verbose())
  #https://api.duckduckgo.com/?q=<your search string>&format=json&pretty=1&no_html=1&skip_disambig=1
  print(resut_search)
  
  
}

https://api.duckduckgo.com/?q=DuckDuckGo&format=json&pretty=1

resut_search<- httr::GET(url = "https://api.duckduckgo.com",
                         query = list(q="DuckDuckGo",format="json",pretty=1
                                                                      ,no_html=1,skip_disambig=1)
,      verbose())
#https://api.duckduckgo.com/?q=<your search string>&format=json&pretty=1&no_html=1&skip_disambig=1
print(resut_search)
http_type(resut_search)
http_error(resut_search)
# Shows raw data which is not structured and readable
jsonRespText<-content(resut_search,as="text") 
jsonRespText
"http://api.duckduckgo.com/?q=DuckDuckGo&format=json&pretty=1"
#write.csv2(data_siret_scrapping,"data/etab_keywords.csv", row.names = TRUE)
