library(httr)
library(jsonlite)
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
  
  params <- list()
  params$grant_type <- "client_credentials"
  
  instance$result_auth <- httr::POST(url = paste(instance$url_insee,'token',sep = "/"),
                            accept_json(),
                            body = params,
                           authenticate(instance$consumer_key, instance$consumer_secret),
                            encode='form',
                            verbose())
  
  
  print(instance$result_auth)
  
  instance$parsed_auth <- jsonlite::fromJSON(content(instance$result_auth, "text"), 
                                             simplifyVector = FALSE)
  instance$token_insee <- instance$parsed_auth$access_token
  print(instance$token_insee)
  #renvoyer le résultat
  return(instance)
}

get_siren.api_insee <-function(objet,num_siren){
  result_siren <- httr::GET( url = objet$url_insee,path=paste(objet$siren_path, num_siren,sep = "/"),  
                             accept_json(),
                             add_headers(Accept='application/json',
                                         Authorization=paste('Bearer',objet$token_insee,sep = ' ')), 
                             verbose())
  
  parsed_siren <- jsonlite::fromJSON(content(result_siren, "text"), simplifyVector = FALSE)
  return(parsed_siren)
  
}

consumer_key <-"6mrzM8nmQFfZZBoZvfpxa8mE_Jka"
consumer_secret <-"ndIxnvi8vaSyHaYHooIBS3OFUqMa"
obj <- api_insee(consumer_key = consumer_key, consumer_secret = consumer_secret)



## parametrage du service INSEE
url_insee  <- "https://api.insee.fr"
path <- "entreprises/sirene/V3"
siren_path  <- "entreprises/sirene/V3/siren"
siret_path <-"entreprises/sirene/V3/siret"
token  <- "token"

## Paramètres d'accès au service 

datas <- "grant_type='client_credentials'"
## l'instrucion curl pour récupérer le TOKEN
#curl -k -d "grant_type=client_credentials" \
#-H "Authorization: Basic Base64(consumer-key:consumer-secret)" \

#base_64 <- paste('Basic',base64_enc(paste(consumer_key,consumer_secret,sep = ':')) ,sep=' ')
#print(base_64)
#authenti2 <-"Authorization: Basic Nm1yek04bm1RRmZaWkJvWnZmcHhhOG1FX0prYTpuZEl4bnZpOHZhU3lIYVlIb29JQlMzT0ZVcU1h"


params <- list()
params$grant_type <- "client_credentials"

result_auth <- httr::POST(url = paste(url_insee,token,sep = "/"),
                   accept_json(),
                   # add_headers(Authorization='Basic Nm1yek04bm1RRmZaWkJvWnZmcHhhOG1FX0prYTpuZEl4bnZpOHZhU3lIYVlIb29JQlMzT0ZVcU1h'),
                   #add_headers(Authorization=base_64),
                   body = params,
                   # body=list(grant_type='client_credentials'),
                    #config=list(grant_type='client_credentials'),
                    authenticate(consumer_key, consumer_secret),
                    encode='form',
                    verbose())


print(result_auth)

parsed <- jsonlite::fromJSON(content(result_auth, "text"), simplifyVector = FALSE)
print(parsed)
token_insee <- parsed$access_token
print(token_insee)

# requete de récupération des info insee à  partir du SIREN
#curl -X GET --header 'Accept: application/json' --header 'Authorization: Bearer 1a458fae-6365-3102-b8d0-d3dfdf05cbf4' 'https://api.insee.fr/entreprises/sirene/V3/siren/193401197'
result_siren <- httr::GET( url = url_insee,path=paste(siren_path, "193401197",sep = "/"),  
                           accept_json(),
                           add_headers(Accept='application/json',
                                      Authorization=paste('Bearer',token_insee,sep = ' ')), 
                           verbose())

parsed_siren <- jsonlite::fromJSON(content(result_siren, "text"), simplifyVector = FALSE)
parsed_siren$uniteLegale
# requete de récupération des info insee à  partir du SIRET
#curl -X GET --header 'Accept: application/json' --header 'Authorization: Bearer 1a458fae-6365-3102-b8d0-d3dfdf05cbf4' 'https://api.insee.fr/entreprises/sirene/V3/siret/19340119700010'



result_siret <- httr::GET( url = url_insee,path=paste(siret_path, "19340119700010",sep = "/"),  
                           accept_json(),
                           add_headers(Accept='application/json',
                                       Authorization=paste('Bearer',token_insee,sep = ' ')), 
                           verbose())

parsed_siret <- jsonlite::fromJSON(content(result_siret, "text"), simplifyVector = FALSE)
#Nom de l'etablissement
parsed_siret$etablissement$uniteLegale$denominationUniteLegale
# nbre d'emplyes
parsed_siret$etablissement$uniteLegale$trancheEffectifsUniteLegale
#NAF
parsed_siret$etablissement$uniteLegale$activitePrincipaleUniteLegale
#adresse
adresse <- paste(parsed_siret$etablissement$adresseEtablissement$numeroVoieEtablissement,
parsed_siret$etablissement$adresseEtablissement$typeVoieEtablissement,
parsed_siret$etablissement$adresseEtablissement$libelleVoieEtablissement,
parsed_siret$etablissement$adresseEtablissement$codePostalEtablissement,
parsed_siret$etablissement$adresseEtablissement$libelleCommuneEtablissement,sep =' ')

adresse






