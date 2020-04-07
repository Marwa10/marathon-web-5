library(httr)
library(jsonlite)
library(dplyr)
library(tidyverse)
###################################
# Creation de la classe api_insee #
###################################
# constructeur de la classe 
api_insee <- function(consumer_key,consumer_secret) {

  #création de l'instance
  instance <- list()
  instance$consumer_key <- consumer_key
  instance$consumer_secret <- consumer_secret
  instance$url_insee  <- "https://api.insee.fr"
  instance$path <- "entreprises/sirene/V3"
  instance$siren_path  <- "entreprises/sirene/V3/siren"
  instance$siret_path <-"entreprises/sirene/V3/siret"
  instance$siret_multi_path <-"entreprises/sirene/V3/siret"
  ## methode get_siren #######
  ###  permet de récupérer les information SIRET ( 9 premiers caractères du SIREN) sous forme json 
  instance$get_siren <-function(num_siren){
    result_siren <- httr::GET( url = instance$url_insee,path=paste(instance$siren_path, num_siren,sep = "/"),  
                               accept_json(),
                               add_headers(Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               verbose())
    
    parsed_siren <- jsonlite::fromJSON(content(result_siren, "text"), simplifyVector = FALSE)
    return(parsed_siren)
    
  }
  ## Méthode get_siret ######
  ##, permet de récupérer les informations de l'établissement à  partir du SIRET
  instance$get_siret <-function(num_siret){
    
    result_siret <- httr::GET( url = instance$url_insee,path=paste(instance$siret_path, num_siret,sep = "/"),  
                               accept_json(),
                               add_headers(Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               verbose())
    
    parsed_siret <- jsonlite::fromJSON(content(result_siret, "text"), simplifyVector = FALSE)

    
   # adresse
    return(parsed_siret)
  }
  ### get_multiple_siret #####
  
  instance$get_multiple_siret <- function (list_of_siret){
   sirets=''
    for(siret in list_of_siret){
      siret= paste('siret',trim(siret),sep = ':')
      if (sirets =='')
        sirets = siret
      else
        sirets <- paste(sirets,siret, sep = ' OR ')
    }
    print(sirets)
    params <- list()
    params$q <- sirets #"siret:19340119700010 OR siret:19340972900020"
    result_siret <- httr::POST( url = paste(instance$url_insee,instance$siret_multi_path,sep = '/'),
                               accept_json(),
                               body = params,
                               add_headers(#Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               encode='form',
                               verbose())
    
    parsed_siret <- jsonlite::fromJSON(content(result_siret, "text"), simplifyVector = FALSE)
    return(parsed_siret)
    
  }
  ###  get_multiple_siret_dataframe ####
  ##
  instance$get_multiple_siret_dataframe<- function(list_of_siret){
    # creation du dataframe
    df <- data.frame(siren=character(),
                     siret=character(),
                     activitePrincipaleUniteLegale=character(),
                     trancheEffectifsEtablissement=integer(),
                     denominationUniteLegale=character(),
                     categorieEntreprise=character(),
                     typeVoieEtablissement=character(),
                     libelleVoieEtablissement=character(),
                     codePostalEtablissement=character(),
                     libelleCommuneEtablissement=character(),
                     stringsAsFactors=FALSE)
    # appel de l'API get_multiple_siret
   result_json <-instance$get_multiple_siret(list_of_siret)
    # recupération des etablissements
   etab <- result_json$etablissements


  # fill the datatframe
    for(i in etab){
      df[nrow(df) + 1,] = list(siren = i$siren,
                               siret=  i$siret,
                               activitePrincipaleUniteLegale= i$uniteLegale$activitePrincipaleUniteLegale,
                               trancheEffectifsEtablissement= i$trancheEffectifsEtablissement,
                               denominationUniteLegale =  i$uniteLegale$denominationUniteLegale,
                               categorieEntreprise= i$uniteLegale$categorieEntreprise,
                               typeVoieEtablissement=  i$adresseEtablissement$typeVoieEtablissement,
                               libelleVoieEtablissement= i$adresseEtablissement$libelleVoieEtablissement,
                               codePostalEtablissement=  i$adresseEtablissement$codePostalEtablissement,
                               libelleCommuneEtablissement=  i$adresseEtablissement$libelleCommuneEtablissement
                               )
    }

    return(df)

  }
  
  ## Constructeur ####
  params <- list()
  params$grant_type <- "client_credentials"
  instance$result_auth <- httr::POST(url = paste(instance$url_insee,'token',sep = "/"),
                            accept_json(),
                            body = params,
                           authenticate(instance$consumer_key, instance$consumer_secret),
                            encode='form',
                            verbose())
  
  
 # print(instance$result_auth)
  
  instance$parsed_auth <- jsonlite::fromJSON(content(instance$result_auth, "text"), 
                                             simplifyVector = FALSE)
  instance$token_insee <- instance$parsed_auth$access_token
 # print(instance$token_insee)
  
  #renvoyer l'instance de a classe 
  return(instance)
}

###########################################
# fin de la classe api_insee
############################################


##### exemple d'appel à  la classe INSEE #######


### utiliser toujours ces credentials
consumer_key <-"6mrzM8nmQFfZZBoZvfpxa8mE_Jka"
consumer_secret <-"ndIxnvi8vaSyHaYHooIBS3OFUqMa"
## instanciation de la classe obligatoire avant tout appel
obj <- api_insee(consumer_key = consumer_key, consumer_secret = consumer_secret)


## premier test avec deux SIRET
info_sirets<-obj$get_multiple_siret_dataframe( c('19340119700010', '19340972900020'))
info_sirets


# récupération des données de stage
options(digits = 7)
data = read.csv2("data/donnees.csv", #stringsAsFactors = FALSE
                 )
data <- subset( data, Numsiret != "NA")

head(data[,"Numsiret"])

format(data[1,"Numsiret"],digits = 22)
as.character( data[200,"Numsiret"])
c_sirets <- c()
for (row in 1:20) {
  siret = data[row,"Numsiret"]
  #print(siret)
  if (!is.null(siret))
    if (!is.na (siret))
      if (siret !='NA'){
          #print(siret)
          c_sirets <- c (c_sirets, siret )
      }
  
}
c_sirets
info_sirets<-obj$get_multiple_siret_dataframe( c_sirets)
info_sirets


# jointure entre les deux datas pour avoir le code ISO
result <- merge(data,info_sirets,by.x="Numsiret", by.y="siret", all= TRUE)




print(info_sirets[["etablissements"]][[2]][["siren"]])
print(info_sirets[["etablissements"]][[2]][["siret"]])
info_sirets[["etablissements"]][[2]][["uniteLegale"]][["activitePrincipaleUniteLegale"]]
info_sirets[["etablissements"]][[2]][["trancheEffectifsEtablissement"]]
info_sirets[["etablissements"]][[2]][["uniteLegale"]][["denominationUniteLegale"]]
info_sirets[["etablissements"]][[2]][["uniteLegale"]][["categorieEntreprise"]]
info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["typeVoieEtablissement"]]
info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["libelleVoieEtablissement"]]
info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["codePostalEtablissement"]]
info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["libelleCommuneEtablissement"]]

## récupération des infos du SIRENE
siren <- "193401197"
info_siren <- obj$get_siren(num_siren =  siren)
print(info_siren)
# recupération des infos du SIRET
siret <- "19340119700010"
info_siret<-obj$get_siret(num_siret = siret)
## exemple dinfo
print(info_siret$etablissement$uniteLegale$denominationUniteLegale)
#Nom de l'etablissement
info_siret$etablissement$uniteLegale$denominationUniteLegale
# nbre d'emplyes
info_siret$etablissement$uniteLegale$trancheEffectifsUniteLegale
#NAF
info_siret$etablissement$uniteLegale$activitePrincipaleUniteLegale
#adresse
adresse <- paste(info_siret$etablissement$adresseEtablissement$numeroVoieEtablissement,
                 info_siret$etablissement$adresseEtablissement$typeVoieEtablissement,
                 info_siret$etablissement$adresseEtablissement$libelleVoieEtablissement,
                 info_siret$etablissement$adresseEtablissement$codePostalEtablissement,
                 info_siret$etablissement$adresseEtablissement$libelleCommuneEtablissement,sep =' ')
