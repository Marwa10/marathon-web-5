library(httr)
library(jsonlite)
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
  ## methode get_siren permet de récupérer les information SIRET ( 9 premiers caractères du SIREN) sous forme json 
  instance$get_siren <-function(num_siren){
    result_siren <- httr::GET( url = instance$url_insee,path=paste(instance$siren_path, num_siren,sep = "/"),  
                               accept_json(),
                               add_headers(Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               verbose())
    
    parsed_siren <- jsonlite::fromJSON(content(result_siren, "text"), simplifyVector = FALSE)
    return(parsed_siren)
    
  }
  ## Méthode get_siret, permet de récupérer les informations de l'établissement à  partir du SIRET
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
  
  #renvoyer l'insatnce de a classe 
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
